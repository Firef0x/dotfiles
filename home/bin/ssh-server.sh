#!/usr/bin/expect

set timeout 30
spawn ssh -p [lindex $argv 0] [lindex $argv 1]
expect {
    "(yes/no)?"
    {send "yes\n";exp_continue}
    "Password:"
    {send "[lindex $argv 2]\n"}
    " password:"
    {send "[lindex $argv 2]\n"}
}
interact