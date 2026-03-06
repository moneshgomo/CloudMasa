# 🚀 AWS Jump Host – Complete Study Notes

> **Intern DevOps Track** | March 6, 2026  
> **Author:** Monesh | **Topic:** Jump Host Implementation using AWS EC2

---

## 📋 Table of Contents

- [What is a Jump Host?](#-what-is-a-jump-host)
- [Architecture Overview](#-architecture-overview)
- [EC2 Instance Setup](#-ec2-instance-setup)
- [Security Group Rules](#-security-group-rules)
- [SSH & SCP Commands](#-ssh--scp-commands)
- [Deploy Script](#-deploy-script--dev--live)
- [User Permissions Setup](#-user-permissions-setup)
- [Issues We Faced & Fixes](#-issues-we-faced--fixes)
- [Key Notes & Takeaways](#-key-notes--takeaways)
- [Quick Reference Cheatsheet](#-quick-reference-cheatsheet)

---

## 🏗️ What is a Jump Host?

A **Jump Host** (also called a **Bastion Server**) is a special server that acts as a **gateway** between your local machine and private/production servers.

You connect to the jump host first → then hop into the private server from there.

### 🏢 Real Life Analogy

| Real World | AWS Equivalent |
|-----------|---------------|
| 🏠 Your Home | Your Laptop (WSL) |
| 🏢 Office Reception (public entrance) | Dev Server – has Public IP |
| 🔒 CEO's Cabin (restricted room) | Live Server – Private IP only |
| Reception → CEO's Cabin | Dev → Live via Private IP |

> ⚠️ **Direct access Home → CEO's Cabin = ❌ Not allowed!**  
> ✅ **You must go through Reception first!**

---

## 🗺️ Architecture Overview

```
Your Laptop (WSL)
     │
     │  ssh -i dev-key.pem ubuntu@34.239.161.114
     │  (Public IP – accessible from internet)
     ▼
Dev Server (Jump Host)
ubuntu@ip-172-31-70-108
     │
     │  ssh -i live-key.pem ubuntu@172.31.74.254
     │  (Private IP – only accessible inside AWS VPC)
     ▼
Live Server (Production)
ubuntu@ip-172-31-74-254
```

### Why This Works – Same VPC!

Both EC2 instances are inside the **same VPC (Virtual Private Cloud)**:

```
AWS Cloud
┌─────────────────────────────────────────────┐
│              VPC (Your Network)              │
│                                             │
│   ┌──────────────┐      ┌──────────────┐   │
│   │  Dev Server  │◄────►│ Live Server  │   │
│   │172.31.70.108 │      │172.31.74.254 │   │
│   └──────────────┘      └──────────────┘   │
│           ▲                                 │
└───────────┼─────────────────────────────────┘
            │ Only Dev Server
            │ is accessible
            │ from internet
       Your Laptop
```

> 💡 Same VPC = Both servers can talk using **Private IPs**. Faster and more secure!

---

## ⚙️ EC2 Instance Setup

### Instance Details

| Setting | Dev Server | Live Server |
|---------|-----------|------------|
| **Name** | `dev-server` | `live-server` |
| **AMI** | Ubuntu 24.04 LTS | Ubuntu 24.04 LTS |
| **Instance Type** | `t3.micro` ✅ Free | `t3.micro` ✅ Free |
| **Public IP** | `34.239.161.114` | `44.197.x.x` |
| **Private IP** | `172.31.70.108` | `172.31.74.254` |
| **Security Group** | `dev-sg` | `live-sg` |
| **SSH Source** | My IP (your laptop) | `172.31.70.108/32` (Dev only) |
| **Key Pair** | `dev-key.pem` | `live-key.pem` |
| **Storage** | 8 GiB | 8 GiB |

### ⚠️ Free Tier Note

> AWS gives you **750 hours/month** free for t3.micro.  
> Running **2 instances** = each can run ~375 hours/month free (750 ÷ 2).  
> **Stop instances when not in use!**

---

## 🔐 Security Group Rules

### What is `/32`?

`/32` in CIDR notation means **"this exact single IP only"**

| CIDR | Meaning |
|------|---------|
| `172.31.70.108/32` | Only THIS one specific IP |
| `172.31.0.0/16` | All IPs in that range |
| `0.0.0.0/0` | Every IP in the world ⚠️ |

### Security Group Configuration

| Server | Rule | Port | Source | Why? |
|--------|------|------|--------|------|
| Dev Server | SSH Allow | 22 | Your IP/32 | Only you can SSH in |
| Live Server | SSH Allow | 22 | `172.31.70.108/32` | Only Dev server can SSH in |

> 🔐 **Live server is completely hidden from the internet. Only Dev server can reach it!**

---

## 🔑 SSH & SCP Commands

### Step 1 – Copy `.pem` Files from Windows to WSL

```bash
# Find your Windows username folder
ls /mnt/c/Users/

# Go to Downloads (replace ASUS with your username)
cd /mnt/c/Users/ASUS/Downloads

# Verify .pem files are there
ls *.pem

# Copy both keys to WSL home
cp dev-key.pem ~/dev-key.pem
cp live-key.pem ~/live-key.pem

# Set correct permissions (REQUIRED! SSH refuses keys with open permissions)
chmod 400 ~/dev-key.pem
chmod 400 ~/live-key.pem

# Verify
ls -la ~/*.pem
# Should show: -r-------- (read only for owner)
```

### Step 2 – SSH Into Dev Server (From Laptop)

```bash
ssh -i ~/dev-key.pem ubuntu@34.239.161.114
#   │  │              │       │
#   │  │              │       └── Dev server Public IP
#   │  │              └── username on server
#   │  └── identity key file flag
#   └── secure shell command
```

### Step 3 – Copy `live-key.pem` to Dev Server (SCP)

```bash
# Run this from LOCAL laptop (NOT inside Dev server!)
scp -i ~/dev-key.pem ~/live-key.pem ubuntu@34.239.161.114:~/live-key.pem
#   │  │              │              │      │               │
#   │  authenticate   file to send   │      Dev IP          save as this name
#   └── secure copy                  └── username@server
```

> 💡 **Why SCP?** Dev server needs `live-key.pem` to unlock Live server.  
> Since the key is on your laptop, we use `scp` to transfer it securely.

### Step 4 – Set Permission on Copied Key

```bash
# Run this INSIDE Dev server
chmod 400 ~/live-key.pem
```

### Step 5 – Jump from Dev → Live Server

```bash
# Run this INSIDE Dev server
ssh -i ~/live-key.pem ubuntu@172.31.74.254
#                              │
#                              └── Live server PRIVATE IP (not public!)
```

### What `-i` flag means

`-i` = **identity file** — tells SSH which key to use to prove your identity

```bash
# Without -i → SSH doesn't know which key to use → Permission denied ❌
ssh ubuntu@172.31.74.254

# With -i → SSH uses your key to unlock → Access granted ✅
ssh -i ~/live-key.pem ubuntu@172.31.74.254
```

### Know Where You Are – Prompt Guide

| Prompt | Location | What You Can Do |
|--------|----------|----------------|
| `monesh@GOMO:~$` | Your Laptop (WSL) | Run scp, local commands |
| `ubuntu@ip-172-31-70-108:~$` | **Dev Server** | SSH to Live, run deploy.sh |
| `ubuntu@ip-172-31-74-254:~$` | **Live Server** | Verify deployed files |

---

## 📦 Deploy Script – Dev → Live

### How It Works

```
Dev Server (myapp/)                Live Server (myapp/)
  └── index.html  ──── rsync ────►   └── index.html  ✅
  └── users.txt   ──── rsync ────►   └── users.txt   ✅
```

### ✅ Final Working Script

```bash
#!/bin/bash
##########################################################
# Description : Deploy Dev → Live using rsync over SSH
# Date        : March 6, 2026
##########################################################

LIVE_SERVER_PRIVATE_IP="172.31.74.254"
LIVE_USER="ubuntu"
LIVE_KEY="/home/ubuntu/live-key.pem"         # ✅ Full path! NOT ~/
APPLICATION_DIRECTORY="/home/ubuntu/myapp/"  # ✅ Full path! NOT ~/

echo "Starting Deployment to Live Server"
echo "Syncing files from Dev -> Live"

rsync -avz -e "ssh -i $LIVE_KEY" \
    $APPLICATION_DIRECTORY \
    $LIVE_USER@$LIVE_SERVER_PRIVATE_IP:~/myapp/

echo "Deployment Done! Changes are now on Live Server!"
```

### rsync Flags Explained

| Flag | Full Name | What it does |
|------|-----------|-------------|
| `-a` | Archive | Preserves permissions, timestamps, symlinks |
| `-v` | Verbose | Shows files being transferred |
| `-z` | Compress | Compresses data during transfer (faster) |
| `-e` | Execute | Specifies remote shell to use (SSH here) |

### How to Use

```bash
# Give execute permission
chmod +x ~/deploy.sh

# Run the script
./deploy.sh

# Verify on Live server
ssh -i /home/ubuntu/live-key.pem ubuntu@172.31.74.254 "cat ~/myapp/index.html"
```

> 💡 **rsync auto-creates** the destination folder on Live server. No need to manually SSH and create it!

---

## 👥 User Permissions Setup

### Permission Plan

| User | Group | Role | `index.html` | `deploy.sh` | Can Deploy? |
|------|-------|------|-------------|------------|------------|
| `monesh` | `admin` | 👑 Admin | `rwx` | `rwx` | ✅ YES |
| `prasanth` | `developer` | 👨‍💻 Developer | `rw-` | `r--` | ❌ NO |
| `venkat` | `viewer` | 👀 Viewer | `r--` | `---` | ❌ NO |

### Commands to Set Up Users

```bash
# ── Create users ──────────────────────────────────────────
sudo useradd -m monesh
sudo useradd -m prasanth
sudo useradd -m venkat

# ── Set passwords ─────────────────────────────────────────
sudo passwd monesh
sudo passwd prasanth
sudo passwd venkat

# ── Create groups ─────────────────────────────────────────
sudo groupadd admin
sudo groupadd developer
sudo groupadd viewer

# ── Add users to groups ───────────────────────────────────
sudo usermod -aG admin     monesh
sudo usermod -aG developer prasanth
sudo usermod -aG viewer    venkat

# ── Set file ownership ────────────────────────────────────
sudo chown ubuntu:admin     ~/deploy.sh
sudo chown ubuntu:developer ~/myapp/index.html

# ── Set permissions ───────────────────────────────────────
sudo chmod 740 ~/deploy.sh         # rwxr----- (admin=rwx, others=r--)
sudo chmod 764 ~/myapp/index.html  # rwxrw-r-- (owner=rwx, dev=rw, viewer=r)

# ── Fix folder access ─────────────────────────────────────
sudo chmod 755 /home/ubuntu
sudo chmod 755 /home/ubuntu/myapp
```

### Understanding `chmod` Numbers

| Number | Symbol | Meaning |
|--------|--------|---------|
| `7` | `rwx` | Read + Write + Execute |
| `6` | `rw-` | Read + Write only |
| `5` | `r-x` | Read + Execute only |
| `4` | `r--` | Read only |
| `0` | `---` | No permission at all |

### Enable Password Login for Users

By default AWS EC2 only allows key-based login. To allow password login:

```bash
# Fix the override config file (AWS-specific!)
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' \
    /etc/ssh/sshd_config.d/60-cloudimg-settings.conf

# Restart SSH
sudo systemctl restart ssh

# Verify
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf
# Should show: PasswordAuthentication yes ✅
```

### Test Each User's Permissions

```bash
# Switch to prasanth and test
sudo su - prasanth
cat /home/ubuntu/myapp/index.html          # ✅ Should work
echo "edit" >> /home/ubuntu/myapp/index.html  # ✅ Should work
/home/ubuntu/deploy.sh                    # ❌ Permission denied
echo "test" >> /home/ubuntu/deploy.sh     # ❌ Permission denied
exit

# Switch to venkat and test
sudo su - venkat
cat /home/ubuntu/myapp/index.html          # ✅ Should work
echo "edit" >> /home/ubuntu/myapp/index.html  # ❌ Permission denied
/home/ubuntu/deploy.sh                    # ❌ Permission denied
exit
```

---

## 🐛 Issues We Faced & Fixes

### ❌ Issue 1 – `~/` Not Expanding in rsync

**Problem:**
```bash
APPLICATION_DIRECTORY="~/myapp/"
# rsync tried to find: /home/ubuntu/~/myapp ❌
```

**Fix:**
```bash
APPLICATION_DIRECTORY="/home/ubuntu/myapp/"  # Use full path ✅
```

---

### ❌ Issue 2 – Space After `=` in Variable

**Problem:**
```bash
LIVE_SERVER_PRIVATE_IP= "172.31.74.254"  # Space breaks variable! ❌
```

**Fix:**
```bash
LIVE_SERVER_PRIVATE_IP="172.31.74.254"  # No space ✅
```

---

### ❌ Issue 3 – Missing `$LIVE_USER@` in rsync Destination

**Problem:**
```bash
rsync ... $APPLICATION_DIRECTORY $LIVE_SERVER_PRIVATE_IP:APPLICATION_DIRECTORY
# Missing $LIVE_USER@ and $ before variable name ❌
```

**Fix:**
```bash
rsync ... $APPLICATION_DIRECTORY $LIVE_USER@$LIVE_SERVER_PRIVATE_IP:~/myapp/ ✅
```

---

### ❌ Issue 4 – Prasanth Got Permission Denied on SSH (Password Auth)

**Problem:**  
AWS Ubuntu EC2 has **TWO SSH config files**. Even after editing the main config, the override file was blocking password login:

```
/etc/ssh/sshd_config              → PasswordAuthentication yes  (ignored!)
/etc/ssh/sshd_config.d/60-cloudimg-settings.conf
                                  → PasswordAuthentication no   (THIS WINS! ❌)
```

**Fix:**
```bash
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' \
    /etc/ssh/sshd_config.d/60-cloudimg-settings.conf

sudo systemctl restart ssh
```

> 🧠 **Lesson:** Always check **both** SSH config files when SSH issues occur!

---

### ❌ Issue 5 – Prasanth Couldn't Read `index.html` (Parent Folder Blocked)

**Problem:**  
Even with correct file permissions, Prasanth got `Permission denied` because the **parent folder** `/home/ubuntu` was restricted:

```
/home/ubuntu/   ← permissions: 700 → Prasanth can't enter! ❌
    └── myapp/
        └── index.html
```

**Fix:**
```bash
sudo chmod 755 /home/ubuntu       # Allow others to enter ✅
sudo chmod 755 /home/ubuntu/myapp # Allow others to enter ✅
```

> 🧠 **Lesson:** Think of folders like doors. Even if the room is open, if the door is locked, you can't get in!

---

## 📝 Key Notes & Takeaways

### 🔐 1. Never Share `.pem` Files
Your `.pem` key is like a house key. Never share it, never commit it to GitHub.  
`chmod 400` ensures no one else can read it.

### 🌐 2. Public IP vs Private IP

| Type | Accessible From | Used For |
|------|----------------|---------|
| Public IP | Anywhere on internet | Dev Server SSH from laptop |
| Private IP | Only inside same VPC | Dev → Live communication |

### 🏗️ 3. VPC = Private Network
Both EC2 servers are in the same VPC so they talk using private IPs.  
This is **faster** and **more secure** than using public IPs.

### ⚙️ 4. AWS Has TWO SSH Config Files
```
/etc/ssh/sshd_config                        ← Main config
/etc/ssh/sshd_config.d/60-cloudimg-settings.conf  ← Override (WINS!)
```
Always check **both files** when SSH issues occur!

### 📁 5. `~/` vs Full Path in Scripts
```bash
# ❌ Inside scripts, ~/ doesn't always expand
APPLICATION_DIRECTORY="~/myapp/"

# ✅ Always use full path in scripts
APPLICATION_DIRECTORY="/home/ubuntu/myapp/"
```

### 🔄 6. rsync is Powerful
- Only transfers **changed files** (incremental sync)
- **Auto-creates** destination folders
- Works over SSH securely
- Use `-avz` flags for best results

### 👥 7. Parent Folder Permissions Matter
Even if a file has correct permissions, if the **parent folder** is restricted (`700`),  
users can't access files inside it. Always use `chmod 755` on folders.

### 🏢 8. Jump Host = Real World Practice
In real companies, production servers are **NEVER** directly accessible.  
Always go through a bastion/jump host. This is **standard DevOps practice**.

---

## ⚡ Quick Reference Cheatsheet

### Full Connection Flow

```bash
# ── From Laptop → Dev Server ─────────────────────────────────
ssh -i ~/dev-key.pem ubuntu@34.239.161.114

# ── Copy live-key to Dev (run from laptop) ───────────────────
scp -i ~/dev-key.pem ~/live-key.pem ubuntu@34.239.161.114:~/live-key.pem

# ── Inside Dev Server → Set permission ───────────────────────
chmod 400 ~/live-key.pem

# ── From Dev Server → Live Server ────────────────────────────
ssh -i ~/live-key.pem ubuntu@172.31.74.254

# ── Deploy changes from Dev to Live ──────────────────────────
./deploy.sh
```

### Useful Verification Commands

```bash
# Check which user you are
whoami

# Check file permissions
ls -la ~/myapp/

# Verify file reached Live server
ssh -i /home/ubuntu/live-key.pem ubuntu@172.31.74.254 "cat ~/myapp/index.html"

# Check SSH service status
sudo systemctl status ssh

# Check password auth setting
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf

# Check user groups
groups monesh
groups prasanth
groups venkat

# Check all created users
cat /etc/passwd | grep -E "monesh|prasanth|venkat"

# Check file ownership
ls -la ~/deploy.sh
ls -la ~/myapp/index.html
```

### Common Errors & Quick Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Permission denied (publickey)` | Wrong key or wrong user | Check `-i` flag and username |
| `No such file or directory` | `~/` not expanding | Use full path `/home/ubuntu/` |
| `Permission denied` on file | Wrong group or folder locked | `chmod 755` on parent folder |
| `PasswordAuthentication` fails | AWS override config | Edit `60-cloudimg-settings.conf` |
| `rsync: change_dir failed` | `~/` in script variable | Use full absolute path |
a
---

## 🗂️ File Structure

```
Dev Server (/home/ubuntu/)
├── deploy.sh          ← Deploy script (admin only: rwxr-----)
├── live-key.pem       ← Key to access Live server (400)
└── myapp/
    └── index.html     ← App file (rw-rw-r--)

Live Server (/home/ubuntu/)
└── myapp/
    └── index.html     ← Synced from Dev via rsync ✅
```

---

## 👤 Users Summary

```
Dev Server Users:
├── ubuntu      → Default AWS user (full access, uses SSH key)
├── monesh      → Admin  (password login, full access)
├── prasanth    → Developer (password login, edit code only)
└── venkat      → Viewer (password login, read only)
```

---

*📅 Last Updated: March 6, 2026 | 🏷️ Tags: AWS, EC2, Jump Host, Bastion, SSH, rsync, DevOps, Linux Permissions*