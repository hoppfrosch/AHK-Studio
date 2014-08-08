Github_Repository(){
	if !owner:=settings.ssn("//github/@owner").text{
		InputBox,owner,Please enter the owner name for this repo,Enter the name associated with your account
		if ErrorLevel
			return m("Nothing happened.  Please try again")
		settings.Add({path:"github",att:{owner:owner}})
	}
	git:=new github(owner)
	if !FileExist("github")
		FileCreateDir,github
	if !rep:=vversion.ssn("//*[@file='" file:=ssn(current(1),"@file").text "']")
		rep:=vversion.Add({path:"info",att:{file:file}})
	repo:=ssn(rep,"@repo").text
	if !(repo){
		InputBox,repo,Please name this repo,Enter a name for this repo.
		if ErrorLevel
			return
		if name:=git.CreateRepo(repo)
			rep.SetAttribute("repo",name)
		Else
			return m("An error occured")
	}Else{
		if !FileExist("github\" repo)
			FileCreateDir,github\%repo%
		uplist:=[],save(),cfiles:=sn(current(1),"file/@file")
		while,filename:=cfiles.item[A_Index-1].text{
			text:=update({get:filename})
			SplitPath,filename,file
			FileRead,compare,github\%repo%\%file%
			StringReplace,compare,compare,`r`n,`n,All
			if (text!=compare){
				FileDelete,github\%repo%\%file%
				FileAppend,%text%,github\%repo%\%file%,utf-8
				uplist[file]:=text
			}
		}
		for filename,text in uplist{
			info:="Updating file " filename
			SplashTextOn,400,150,Updating Files,%info%
			IniRead,file,github\%repo%.ini,%filename%,sha,0
			if !(file){
				git.CreateFile(repo,filename,text,"First Commit","Chad Wilson","maestrith@gmail.com")
			}Else{
				git.update(repo,filename,text,"Working on the class")
			}
		}
		SplashTextOff
	}
}