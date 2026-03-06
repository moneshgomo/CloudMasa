# 🔐 SSH Password Authentication – Issue & Fix

> **Topic:** Enabling Password Login on AWS EC2 Ubuntu  
> **Date:** March 6, 2026  
> **Author:** Monesh | Intern DevOps Track

---

## 📋 Table of Contents

- [What Happened](#-what-happened)
- [Why We Needed Password Login](#-why-we-needed-password-login)
- [The Error](#-the-error)
- [Why The Error Occurred](#-why-the-error-occurred)
- [Root Cause – Two Config Files](#-root-cause--two-config-files)
- [Step by Step Fix](#-step-by-step-fix)
- [Verify The Fix](#-verify-the-fix)
- [Key Takeaways](#-key-takeaways)

---

## 🔍 What Happened

We created 3 users on the Dev server:

```
monesh    → Admin
prasanth  → Developer
venkat    → Viewer
```

We wanted **prasanth** to SSH into the Dev server using just a **username + password**  
(without a `.pem` key file).

---

## 🎯 Why We Needed Password Login

By default, AWS EC2 only allows **key-based login** (`.pem` file).

```
Default AWS EC2 login:
✅ SSH key login  (ubuntu user with .pem file)
❌ Password login (blocked by default)
```

Since prasanth and venkat are **intern/team members** who don't have a `.pem` file,  
we needed to enable **password-based SSH login** for them.

---

## ❌ The Error

When prasanth tried to connect:

```bash
ssh prasanth@34.239.161.114
```

He got this immediately — **no password prompt at all!**

```
prasanth@34.239.161.114: Permission denied (publickey)
```

> ⚠️ Notice: It didn't even ask for a password!  
> It went straight to **Permission denied** — that means password login was completely disabled.

---

## 🤔 Why The Error Occurred

### Our First Attempt (Wrong Fix)

We edited the **main SSH config file**:

```bash
sudo vim /etc/ssh/sshd_config
```

Found this line and uncommented it:

```bash
# Before (commented out = disabled)
#PasswordAuthentication yes

# After (uncommented = enabled)
PasswordAuthentication yes
```

Then restarted SSH:

```bash
sudo systemctl restart ssh
```

**But prasanth still got Permission denied! ❌**

### Why Didn't It Work?

Because **AWS Ubuntu EC2 has TWO SSH config files** and we only edited one!

---

## 🔎 Root Cause – Two Config Files

### File 1 – Main Config (We Edited This)

```
/etc/ssh/sshd_config
```

```bash
# What we set:
PasswordAuthentication yes   ← we set this ✅
```

### File 2 – AWS Override Config (We Missed This!)

```
/etc/ssh/sshd_config.d/60-cloudimg-settings.conf
```

```bash
# AWS default:
PasswordAuthentication no    ← this was STILL blocking! ❌
```

### How SSH Reads Config Files

```
SSH reads sshd_config first...
     │
     │ then reads sshd_config.d/*.conf files
     │
     └── The .conf.d files OVERRIDE the main config!
```

So even though main config said `yes`, the override file said `no` — and **override always wins!**

### Real Life Analogy 🏢

```
HR Manual (sshd_config)
────────────────────────
Rule: Employees can enter using ID card OR password ✅

CEO Special Order (60-cloudimg-settings.conf)
─────────────────────────────────────────────
Rule: Only ID card allowed, NO password! ❌

→ CEO's order ALWAYS overrides HR manual!
```

### How We Found The Problem

```bash
# We ran this command to check both files
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf
```

Output:
```
PasswordAuthentication no   ← FOUND IT! This was the real culprit ❌
```

---

## 🛠️ Step by Step Fix

### Step 1 – Check Main Config First

```bash
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config
```

Expected output:
```
PasswordAuthentication yes  ✅
```

If it says `no` → edit the file:

```bash
sudo vim /etc/ssh/sshd_config
```

Find and change:
```bash
# Change this:
PasswordAuthentication no

# To this:
PasswordAuthentication yes
```

Save: `ESC` → `:wq` → `Enter`

---

### Step 2 – Check the Override Config File (AWS Specific!)

```bash
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf
```

If output shows:
```
PasswordAuthentication no   ← Fix this!
```

---

### Step 3 – Fix the Override Config File

**Option A – Using sed command (Quick fix):**

```bash
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' \
    /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
```

**Option B – Using vim (Manual fix):**

```bash
sudo vim /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
```

Find:
```
PasswordAuthentication no
```

Change to:
```
PasswordAuthentication yes
```

Save: `ESC` → `:wq` → `Enter`

---

### Step 4 – Restart SSH Service

```bash
sudo systemctl restart ssh
```

---

### Step 5 – Verify SSH is Running

```bash
sudo systemctl status ssh
```

Expected output:
```
● ssh.service - OpenBSD Secure Shell server
     Active: active (running) ✅
```

---

## ✅ Verify The Fix

### Check Both Config Files Are Correct

```bash
# Check main config
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config

# Check override config
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf
```

Both should show:
```
PasswordAuthentication yes ✅
```

### Test Prasanth's Login

```bash
ssh prasanth@34.239.161.114
```

Now it should ask for password:
```
prasanth@34.239.161.114's password:  ← Password prompt appears ✅
```

Enter password → Login successful! 🎉

```
Welcome to Ubuntu 24.04.3 LTS
ubuntu@ip-172-31-70-108:~$  ✅
```

---

## 📊 Before vs After

| | Before Fix | After Fix |
|--|-----------|----------|
| Main config | `yes` ✅ | `yes` ✅ |
| Override config | `no` ❌ | `yes` ✅ |
| Password login | ❌ Blocked | ✅ Working |
| Prasanth SSH | Permission denied | Login successful |

---

## 🔐 Does This Affect Key-Based Login?

**NO! ✅** Enabling password login does NOT disable key-based login.

```
After the fix:
✅ SSH key login  (ubuntu user with dev-key.pem) → Still works!
✅ Password login (prasanth, venkat, monesh)     → Now works!
```

Think of it like your phone:

```
Before: Only fingerprint unlock
After:  Fingerprint unlock ✅ + PIN unlock ✅ (both work!)
```

---

## 📝 Key Takeaways

### 1️⃣ AWS Ubuntu EC2 Has TWO SSH Config Files

| File | Purpose |
|------|---------|
| `/etc/ssh/sshd_config` | Main SSH config |
| `/etc/ssh/sshd_config.d/60-cloudimg-settings.conf` | AWS override config |

> ⚠️ **Always check BOTH files when SSH issues occur!**

### 2️⃣ Override Config Always Wins

```
sshd_config (main)     → lower priority
sshd_config.d/*.conf   → HIGHER priority (overrides main!)
```

### 3️⃣ Quick Diagnostic Commands

```bash
# Check what's blocking SSH
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf

# Check SSH service
sudo systemctl status ssh

# Check if user account is locked
sudo passwd -S prasanth
# "P" = password set ✅
# "L" = account locked ❌
```

### 4️⃣ Always Restart SSH After Changes

```bash
sudo systemctl restart ssh
```

> Without restarting, changes won't take effect!

---

## 🗺️ Complete Fix Flow

```
Problem: prasanth gets "Permission denied" immediately
     │
     ▼
Step 1: Check main config
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config
     │
     ▼
Step 2: Check override config  ← THIS WAS THE REAL ISSUE!
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf
     │
     ▼
Step 3: Fix override config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' \
    /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
     │
     ▼
Step 4: Restart SSH
sudo systemctl restart ssh
     │
     ▼
Step 5: Test login
ssh prasanth@34.239.161.114
     │
     ▼
✅ Password prompt appears → Login successful!
```

---

*📅 Date: March 6, 2026 | 🏷️ Tags: AWS, EC2, SSH, PasswordAuthentication, Ubuntu, DevOps, Security*
