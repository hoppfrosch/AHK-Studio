testing(){
	text:=csc().gettext()
	pos:=1,list:=""
	while,pos:=RegExMatch(text,code_explorer.function,found,pos){
		text1:=found.1
		text1:=RegExReplace(text1,"_"," ")
		StringUpper,text1,text1,T
		list.=text1 "`n"
		pos:=found.Pos(1)+1
	}
	clipboard:=list
}