#!/bin/bash

mkdir -p ~/Intern/ShellScripting_Task_1
cd ~/Intern/ShellScripting_Task_1 || exit

cat > DiamondPattern.java << EOF
public class DiamondPattern {
    public static void main(String[] args) {
        int n = 5;
        for (int i = 1; i <= n; i++) {
            for (int j = i; j < n; j++) System.out.print(" ");
            for (int j = 1; j <= (2*i-1); j++) System.out.print("*");
            System.out.println();
        }
        for (int i = n-1; i >= 1; i--) {
            for (int j = n; j > i; j--) System.out.print(" ");
            for (int j = 1; j <= (2*i-1); j++) System.out.print("*");
            System.out.println();
        }
    }
}
EOF

chmod 644 DiamondPattern.java

javac DiamondPattern.java

java DiamondPattern