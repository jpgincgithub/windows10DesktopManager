# Windows 10 Desktop Manager
An Autohotkey desktop manager

----

###Description

This is a macro which allows you to:

1. Move to another virtual desktop using keyboard shortcuts. By default the shortcut is the Capslock key + a number
2. Move the current active window to a specific virtual desktop. By default this shortcut is windows key + shift + a number

###Using the Desktop Manager

To use this script you need [Autohotkey](https://autohotkey.com/) installed. Once Autohtokey is installed simply download these files and run windows10.ahk

You can specify an options object in windows10.ahk which is used to setup hotkeys in the JPGIncDesktopManagerClass. By default the settings object looks like this:

```autohotkey
options := {"goToDesktopModKey" : "Capslock" ;capslock + number number jumps to desktop
	,"moveWindowModKey" : "+#" ;windows key + shift + number moves the active window to a desktop
	,"postChangeDesktop" : Func("afterDesktopChangeTurnOffCapslock").bind()} ;after moving the active window turn off capslock
```

###Options
You can specify the following options using a simple key/value [Associative array](https://autohotkey.com/docs/Objects.htm#Usage_Associative_Arrays)


 **No keys (Multitasking view hotkeys only)**
 
Pressing numbers 1 through 0 while in the multi tasking view (the view that comes up after pressing win + tab) will go to the desktop number that you pressed

**goToDesktopModKey Key**

Specify a hotkey (which will be combined with numbers 1 through 0)  for going to a desktop.
Example: ```"d```  will become a hotkey with the combination: 'd + number' 

**moveWindowModKey Key**

Specify a hotkey (which will be combined with numbers 1 through 0) for moving the active window to a desktop. For
Example: ```"+#"```  will become a hotkey with the combination: 'shift + windows key + number' 

**postChangeDesktop Key** 

Specify a function name or function object. The function that will be called after moving desktops

**postMoveWindow Key**

Specify a function name or function object. The function that will be called after moving the active window to a desktop

**Further reading**

Checkout the [Autohotkey hotkeys](https://autohotkey.com/docs/Hotkeys.htm) documentation for more information on valid hotkey combos

Checkout the [Autohotkey function objects](https://autohotkey.com/docs/objects/Functor.htm) documentation for more information on how to create callbacks
