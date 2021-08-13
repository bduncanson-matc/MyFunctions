# MyFunctions

Using the Zorlen Functions Library I am taking requests from 1.12.1 players on macros that
they would like me to make for them.

## Getting Started / Instalation

**Installing Zorlen:**

Outside the 1.12.1 client (before you load the game) download Zorlen from either this repo or at the website https://legacy-wow.com/vanilla-addons/zorlen/. Once downloaded extract the files contents
 to your "*yourWoWFolder\Interface\AddOns*" folder.

**Installing the MyFunctions.Lua File:**

Download any of the MyFunctions.lua files located in this repo or create your own MyFunctions.lua file. Once completed move/copy your MyFunctions.lua file to inside the "*./Interface/Addons/Zorlen*"

## Function's Format

Most of my Lua macros the functions will have a format similar to:

    function foo()
	    if somethingHappens then
            doSomethingCool
        else
            doSomethingElseCool
        end
    end

If this function has been properly placed inside the Zorlen/MyFunctions.lua file the foo function becomes global.
Which means it can now be called from the chat frame by simply replacing the word function with /run and then ignoring everything after the ()
in the functions name.

So, the above function as text inside a macro would be as simple as:

    /run foo()


##Client Instructions
At this point you should have Zorlen installed as well as a MyFunctions.lua file directory. If that is true then boot up a 1.12.1 client and once you reach the character selection screen click the addon
button in the bottom left corner and scroll down to the addon Zorlen making sure it is loaded.
Close the addons window and then enter the world.

After the loading screen open your macro interface (/m in the chat window or from the main menu).
Create a new macro and inside the box enter:

    /run yourFunctionsName()

Give the macro an image and a name and then its ready for use and can be dragged to an action bar. You macro should be
functional at this point soHotkey it or click if that's you style.

##About me and this project:
I am a passionate programmer who oddly enough still gets a crazy amount of joy from writing macros for other players. Especially
since I don’t have much time to play anymore. I decided to create this repo for the sole purpose of sharing my passion
for writing Lua macros with the 1.12.1 community. So, to any 1.12.1 players that
are reading this feel free to send me a macro/functions you would like me to make for you and I'll get to work.

    Discord: BdunK#4643


Will put requested functions in a file inside a folder with the name of the requester.

I just Want to end this by say thanks to the creators of Zorlen for providing a useful library, and the players that
continuously feed my need to write these solutions.





