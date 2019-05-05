# Portforge
This script is intended to open as many sockets as you wish (between 1024 - 65535).<br>
Lower than 1024 works too but you have to be a root user for that.<br>

This can be useful when you don't want people to map out your device<br>
to see what you're running and what not, so it's a small step to defeat reconnaissance.<br>

### Technology from the core
Portforge.cr uses a technique built-in the Crystal compiler called Fibers.<br>
They are very much like system threads but Fibers is a lot more lightweight<br>
& the execution is managed through the process [1](https://crystal-lang.org/docs/guides/concurrency.html).<br>

The larger range you pick, the longer it takes for the script to<br>
load up every socket but I've tried my best to optimize the script<br>
so it should just take a couple of minutes (depending on the system of course).<br>

### Under the hood
The script works in 2 steps.<br>
It first performs its own scan on the system to see which port is already open.<br>
The open ports is then put on one list and the closed ports is put on another list.<br>
The next step is opening the closed ports, so the script picks the list with all the closed<br>
ports and opens a socket on every one of them.<br>

While the main fiber is opening a socket on every port,<br>
another fiber is called under the main one which listens for incoming connections and closes it directly.<br>
This process is repeated indefinitely, or until you interrupt the script.<br>

### Getting started (you only need to do this once)
```
crystal build portforge.cr
```

### Requirement
- [The compiler](https://crystal-lang.org/reference/installation/)


### Usage
```
./portforge IP startport endport
```

### Demo
The first picture is portforge.cr running and the second one is the result from an Nmap scan.<br>
As you can see, Nmap thinks I'm running all these services when in reality, it is just portforge.cr running.<br>
<img src="https://raw.githubusercontent.com/Beyarz/portforge.cr/master/demo.png" height="160%" width="48%" />
<img src="https://raw.githubusercontent.com/Beyarz/portforge.cr/master/result.png" height="160%" width="48%" />
