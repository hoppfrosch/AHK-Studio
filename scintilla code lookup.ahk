scintilla_code_lookup(){
	static slist,cs
	scintilla(),slist:=scintilla.sn("//commands/item"),scl:=setup(8,1)
	Gui,Add,Edit,Uppercase w500 gcodesort vcs
	Gui,Add,ListView,w720 h500 -Multi,Name|Code|Syntax
	Gui,Add,Radio,xm Checked gcodesort,Commands
	Gui,Add,Radio,x+5 gcodesort,Constants
	Gui,Add,Button,xm ginsert Default,Insert code into script
	Gui,Add,Button,gdocsite,Goto Scintilla Document Site
	while,sl:=slist.item(A_Index-1)
		LV_Add("",ssn(sl,"@name").text,ssn(sl,"@code").text,ssn(sl,"@syntax").text)
	Gui,show,,Scintilla Code Lookup
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	hotkeys([8],{up:"sclup",down:"scldn"})
	return
	sclup:
	scldn:
	return lv_select(8,A_ThisLabel="sclup"?-1:1)
	docsite:
	Run,http://www.scintilla.org/ScintillaDoc.html
	return
	codesort:
	Gui,8:Submit,Nohide
	Gui,8:Default
	GuiControl,-Redraw,SysListView321
	LV_Delete()
	for a,b in {1:"commands",2:"constants"}{
		ControlGet,check,Checked,,Button%a%,% hwnd([8])
		value:=b
		if Check
			break
	}
	slist:=scintilla.sn("//" value "/*[contains(@name,'" cs "')]")
	while,(sl:=xml.ea(slist.item(A_Index-1))).name
		LV_Add("",sl.name,sl.code,sl.syntax)
	LV_Modify(1,"Select Vis Focus")
	GuiControl,+Redraw,SysListView321
	return
	insert:
	LV_GetText(code,LV_GetNext(),2)
	sc:=csc()
	DllCall(sc.fn,"Ptr",sc.ptr,"UInt",2003,int,sc.2008,astr,code,"Cdecl")
	npos:=sc.2008+StrLen(code)
	sc.2160(npos,npos)
	hwnd({rem:8})
	return
	lookupud:
	Gui,8:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
	8GuiClose:
	8GuiEscape:
	hwnd({rem:8})
	return
}