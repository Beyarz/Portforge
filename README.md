# portforge.cr
This script is intended to open as many sockets as you which between 1024 - 65535.
Lower than 1024 works too but you have to be a root user for that.

This can be useful when you don't want people to map out your device
and see what you're running and not, so it's a small step to defeat reconnaissance.

Portforge uses a technique built-in the Crystal compiler called Fibers.
They are very much like system threads but Fibers is a lot more lightweight
& the execution is managed through the process [1](https://crystal-lang.org/docs/guides/concurrency.html).

The larger range you pick, the longer it takes for the script to
load up every socket but I've tried my best to optimize the script
so it should just take a couple of minutes (depending on the system of course).

The script works in 2 steps:
It first performs its own scan on the system to see which port is already open.
The open ports is then put on one list and the closed ports are put on another list.
The next step is opening the closed ports, so the script picks the list with all the closed
ports and opens a socket on every one of them.

While the main fiber is opening a socket on every port,
another fiber is called under the main one which listens for incoming connections and closes it directly.
This process is repeated indefinitely, or until you interrupt the script.

Usage:
```
./portforge IP startport endport
```
Demo - the first picture is portforge.cr running and the second one is the result from an Nmap scan.
As you can see, Nmap things I'm running all these services when in reality, it is just portforge.cr running.</br>
<img src="https://raw.githubusercontent.com/Beyarz/portforge.cr/master/demo.png" height="160%" width="48%" />
<img src="https://raw.githubusercontent.com/Beyarz/portforge.cr/master/result.png" height="160%" width="48%" />
