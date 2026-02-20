- File Permissions

``` bash

monesh@GOMO:~/Intern/ShellScripting_Task_1$ touch Main.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls -l
total 0
-rw-r--r-- 1 monesh monesh 0 Feb 20 12:39 Main.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ vim Main.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ cat Main.java
public class DiamondPattern {
    public static void main(String[] args) {
        int n = 5;

        for (int i = 1; i <= n; i++) {
            for (int j = i; j < n; j++) {
                System.out.print(" ");
            }
            for (int j = 1; j <= (2 * i - 1); j++) {
                System.out.print("*");
            }
            System.out.println();
        }

        for (int i = n - 1; i >= 1; i--) {
            for (int j = n; j > i; j--) {
                System.out.print(" ");
            }
            for (int j = 1; j <= (2 * i - 1); j++) {
                System.out.print("*");
            }
            System.out.println();
        }
    }
}
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls -l
total 4
-rw-r--r-- 1 monesh monesh 676 Feb 20 12:39 Main.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ chmod 744 Main.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls -l
total 4
-rwxr--r-- 1 monesh monesh 676 Feb 20 12:39 Main.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ javac Main.java
Main.java:1: error: class DiamondPattern is public, should be declared in a file named DiamondPattern.java
public class DiamondPattern {
       ^
1 error
monesh@GOMO:~/Intern/ShellScripting_Task_1$ mv Main.java DiamondPattern.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls
DiamondPattern.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls -l
total 4
-rwxr--r-- 1 monesh monesh 676 Feb 20 12:39 DiamondPattern.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ javac DiamondPattern.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ java DiamondPattern
    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *
monesh@GOMO:~/Intern/ShellScripting_Task_1$ chmod 444 DiamondPattern.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ chmod 444 DiamondPattern.class
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls -l
total 8
-r--r--r-- 1 monesh monesh 713 Feb 20 12:40 DiamondPattern.class
-r--r--r-- 1 monesh monesh 676 Feb 20 12:39 DiamondPattern.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ mv DiamondPattern.java new_Diamond.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls
DiamondPattern.class  new_Diamond.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ cd ..
monesh@GOMO:~/Intern$ ls
ShellScripting_Task_1
monesh@GOMO:~/Intern$ ls -l
total 4
drwxr-xr-x 2 monesh monesh 4096 Feb 20 12:42 ShellScripting_Task_1
monesh@GOMO:~/Intern$ chmod 454 ShellScripting_Task_1
monesh@GOMO:~/Intern$ ls -l
total 4
dr--r-xr-- 2 monesh monesh 4096 Feb 20 12:42 ShellScripting_Task_1
monesh@GOMO:~/Intern$ cd ShellScripting_Task_1
-bash: cd: ShellScripting_Task_1: Permission denied
monesh@GOMO:~/Intern$ ls
ShellScripting_Task_1
monesh@GOMO:~/Intern$ ls -l
total 4
dr--r-xr-- 2 monesh monesh 4096 Feb 20 12:42 ShellScripting_Task_1
monesh@GOMO:~/Intern$ cd ShellScripting_Task_1
-bash: cd: ShellScripting_Task_1: Permission denied
monesh@GOMO:~/Intern$ ls -l
total 4
dr--r-xr-- 2 monesh monesh 4096 Feb 20 12:42 ShellScripting_Task_1
monesh@GOMO:~/Intern$ chmod 544 ShellScripting_Task_1
monesh@GOMO:~/Intern$ ls -l
total 4
dr-xr--r-- 2 monesh monesh 4096 Feb 20 12:42 ShellScripting_Task_1
monesh@GOMO:~/Intern$ cd ShellScripting_Task_1
monesh@GOMO:~/Intern/ShellScripting_Task_1$ ls
DiamondPattern.class  new_Diamond.java
monesh@GOMO:~/Intern/ShellScripting_Task_1$ mv new_Diamond.java DiamondPattern.java
mv: cannot move 'new_Diamond.java' to 'DiamondPattern.java': Permission denied
monesh@GOMO:~/Intern/ShellScripting_Task_1$ rm DiamondPattern.class
rm: remove write-protected regular file 'DiamondPattern.class'? y
rm: cannot remove 'DiamondPattern.class': Permission denied
monesh@GOMO:~/Intern/ShellScripting_Task_1$

```

