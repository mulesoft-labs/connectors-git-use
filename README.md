# connectors-git-use

## Examples

This directory contains bash scripts with examples of how github uses cases for connectors development.

[Run the script](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html#sect_02_01_03)

If you're a Windows 10 User, take a look at [this post](https://msdn.microsoft.com/en-us/commandline/wsl/about).

* All examples require a target directory where it creates a kiwi dir. Make sure the directory is not already there.
* To obtain the graph of the commits history use:

```
git log --oneline --parents --decorate --all --topo-order --graph
```
