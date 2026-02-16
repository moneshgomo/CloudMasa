## Task 1

1. Create a folder named **Game**.

2. Inside the **Game** folder:
   - Create a file named **Carrom.txt**.
   - Add the text:
     ```
     I love this game
     ```

3. Go back to the parent directory.

4. Create another folder named **Movie**.

5. Inside the **Movie** folder:
   - Create a file named **Master.txt** and write:
     ```
     vijay
     ```
   - Create another file named **Leo.txt** and write:
     ```
     Lokesh
     ```

6. Move **Carrom.txt** from the **Game** folder to the **Movie** folder.

7. Move both **Leo.txt** and **Master.txt** from the **Movie** folder to the **Game** folder.

8. Verify:
   - The **Game** folder should contain:
     ```
     Leo.txt
     Master.txt
     ```
   - The **Movie** folder should contain:
     ```
     Carrom.txt
     ```

9. Display the contents of each file to confirm.

``` bash
gomodev@GOMO:~/intern/Day_1$ mkdir Game
gomodev@GOMO:~/intern/Day_1$ cd Game/
gomodev@GOMO:~/intern/Day_1/Game$ vim Carrom.txt
gomodev@GOMO:~/intern/Day_1/Game$ cat Carrom.txt
I love this game
gomodev@GOMO:~/intern/Day_1/Game$ cd ..
gomodev@GOMO:~/intern/Day_1$ pwd
/home/gomodev/intern/Day_1
gomodev@GOMO:~/intern/Day_1$ mkdir Movie
gomodev@GOMO:~/intern/Day_1$ cd Movie/
gomodev@GOMO:~/intern/Day_1/Movie$ vim Master.txt
gomodev@GOMO:~/intern/Day_1/Movie$ vim Master.txt
gomodev@GOMO:~/intern/Day_1/Movie$ cat Master.txt
vijay
gomodev@GOMO:~/intern/Day_1/Movie$ vim Leo.txt
gomodev@GOMO:~/intern/Day_1/Movie$ cat Leo.txt
Lokesh
gomodev@GOMO:~/intern/Day_1/Movie$ ls
Leo.txt  Master.txt
gomodev@GOMO:~/intern/Day_1/Movie$ cd ..
gomodev@GOMO:~/intern/Day_1$ ls
Game  Movie
gomodev@GOMO:~/intern/Day_1$ cd Game/
gomodev@GOMO:~/intern/Day_1/Game$ LS
LS: command not found
gomodev@GOMO:~/intern/Day_1/Game$ ls
Carrom.txt
gomodev@GOMO:~/intern/Day_1/Game$ pwd
/home/gomodev/intern/Day_1/Game
gomodev@GOMO:~/intern/Day_1/Game$ cd ..
gomodev@GOMO:~/intern/Day_1$ ls
Game  Movie
gomodev@GOMO:~/intern/Day_1$ cd Game/
gomodev@GOMO:~/intern/Day_1/Game$ ls
Carrom.txt
gomodev@GOMO:~/intern/Day_1/Game$ mv Carrom.txt /home/gomodev/intern/Day_1/Game
mv: 'Carrom.txt' and '/home/gomodev/intern/Day_1/Game/Carrom.txt' are the same file
gomodev@GOMO:~/intern/Day_1/Game$ mv Carrom.txt /home/gomodev/intern/Day_1/Movie
gomodev@GOMO:~/intern/Day_1/Game$ ls
gomodev@GOMO:~/intern/Day_1/Game$ cd ..
gomodev@GOMO:~/intern/Day_1$ ls
Game  Movie
gomodev@GOMO:~/intern/Day_1$ cd Movie
gomodev@GOMO:~/intern/Day_1/Movie$ ls
Carrom.txt  Leo.txt  Master.txt
gomodev@GOMO:~/intern/Day_1/Movie$ mv Leo.txt /home/gomodev/intern/Day_1/Game
gomodev@GOMO:~/intern/Day_1/Movie$ ls
Carrom.txt  Master.txt
gomodev@GOMO:~/intern/Day_1/Movie$ mv Master.txt /home/gomodev/intern/Day_1/Game
gomodev@GOMO:~/intern/Day_1/Movie$ ls
Carrom.txt
gomodev@GOMO:~/intern/Day_1/Movie$ cd ..
gomodev@GOMO:~/intern/Day_1$ ls
Game  Movie
gomodev@GOMO:~/intern/Day_1$ cd Game/
gomodev@GOMO:~/intern/Day_1/Game$ ls
Leo.txt  Master.txt
gomodev@GOMO:~/intern/Day_1/Game$ cd ..
gomodev@GOMO:~/intern/Day_1$ cd Movie
gomodev@GOMO:~/intern/Day_1/Movie$ ls
Carrom.txt
gomodev@GOMO:~/intern/Day_1/Movie$ cat Carrom.txt
I love this game
gomodev@GOMO:~/intern/Day_1/Movie$ cd ..
gomodev@GOMO:~/intern/Day_1$ cd Movie
gomodev@GOMO:~/intern/Day_1/Movie$ ls
Carrom.txt
gomodev@GOMO:~/intern/Day_1/Movie$ cd ..
gomodev@GOMO:~/intern/Day_1$ cd Game
gomodev@GOMO:~/intern/Day_1/Game$ ls
Leo.txt  Master.txt
gomodev@GOMO:~/intern/Day_1/Game$ cat Leo.txt
Lokesh
gomodev@GOMO:~/intern/Day_1/Game$ cat Master.txt
vijay
gomodev@GOMO:~/intern/Day_1/Game$

```
