class DesktopMapperClass
{
	DesktopMarkerClass := Object()
	
	getWindowDesktopIdAddress := ""
	isWindowOnCurrentVirtualDesktopAddress := ""
	moveWindowToDesktop  := ""
	iVirtualDesktopManager := ""
	
	__new(iVirtualDesktopManager, isWindowOnCurrentVirtualDesktopAddress, getWindowDesktopIdAddress)
	{
		this.iVirtualDesktopManager := iVirtualDesktopManager
		this.isWindowOnCurrentVirtualDesktopAddress := isWindowOnCurrentVirtualDesktopAddress
		this.getWindowDesktopIdAddress := getWindowDesktopIdAddress

		return this
	}
	
	mapVirtualDesktops() 
	{
		currentDesktop := new DesktopMarkerClass(this.getWindowDesktopIdAddress, this.isWindowOnCurrentVirtualDesktopAddress, this.iVirtualDesktopManager)
		send ^#{Left 10}
		this.DesktopMarkers := Object()
		this._createMarkers()

		this._returnToDesktop(currentDesktop)
		;~ debugger("markers created")
		return this
	}
	
	getGuidOfDesktop(desktopNumber)
	{
		;~ this._verifyDesktopMapping()
		return this.DesktopMarkers[desktopNumber]
	}
	
	getHwndOfDesktop(desktopNumber)
	{
		;~ this._verifyDesktopMapping()
		return this.DesktopMarkers[desktopNumber].hwnd
	}
	
	/*
	 * returns the desktop number or -1 if there was an error
	 *
	 * if tryRemapping is true then if the current desktop isn't mapped we will try mapping it again
	 */
	getCurrentDesktopNumber(tryRemapping := true) 
	{
		this._verifyDesktopMapping()
		;~ debugger("desktop mapping verified about to find the current desktop number")
		loop, % this.DesktopMarkers.MaxIndex()
		{
			if(this.DesktopMarkers[A_Index].isDesktopCurrentlyActive())
			{
				debugger(A_index "is the active desktop")
				return A_Index
			}
		}
		;debug
		
		MsgBox i couldnt find an active desktop
		if(tryRemapping) 
		{
			this.mapVirtualDesktops()
			return this.getCurrentDesktopNumber(false)
		}		
		
		return -1
	}
	
	/*
	 * fixes up mapping by removing any markers that have moved desktop 
	 * (this happens when the user closes a virtual desktop)
	 *
	 * does not map new desktops
	 */
	_verifyDesktopMapping() 
	{
		verifiedDesktopMarkerClass := Object()
		
		loop, % this.DesktopMarkers.MaxIndex()
		{
			if(this.DesktopMarkers[A_Index].isOnSameDesktop())
			{
				verifiedDesktopMarkerClass.Insert(this.DesktopMarkers[A_Index])
			}
		}
		this.DesktopMarkers := verifiedDesktopMarkerClass
		return this
	}
	
	_createMarkers() 
	{
		while(true)
		{
			debugger("about to create a gui " A_index)
			nextMarker := new DesktopMarkerClass(this.getWindowDesktopIdAddress, this.isWindowOnCurrentVirtualDesktopAddress, this.iVirtualDesktopManager)
			if(this._desktopAlreadyMapped(nextMarker)) 
			{
				debugger("the thing is mapped!")
				return this
			}
			this.DesktopMarkers.Insert(nextMarker)
			send ^#{right}
		}
		return this
	}
	
	_desktopAlreadyMapped(otherDesktop) 
	{
		loop, % this.DesktopMarkers.MaxIndex()
		{
			debugger(this.DesktopMarkers[A_Index].virtualDesktopId "`n" otherDesktop.virtualDesktopId)
			if(this.DesktopMarkers[A_Index].virtualDesktopId == otherDesktop.virtualDesktopId)
			{
				return true
			}
		}
		;debug
		return false
	}
	
	_returnToDesktop(returnTo)
	{
		currentDesktop := this.getCurrentDesktopNumber()
		returnToDesktopNumber := 1
		
		loop, % this.DesktopMarkers.MaxIndex()
		{
			if(this.DesktopMarkers[A_Index].virtualDesktopId == returnTo.virtualDesktopId)
			{
				debugger("I need to return to " A_index)
				returnToDesktopNumber := A_Index
				break
			}
		}
		
		distanceToMove := currentDesktop - returnToDesktopNumber
		absDistanceToMove := Abs(distanceToMove)
		
		if(distanceToMove < 0)
		{
			send ^#{right %absDistanceToMove%}
		} else 
		{
			send ^#{left %absDistanceToMove%}
		}
		
		return this
	}
}