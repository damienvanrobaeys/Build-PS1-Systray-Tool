Param
 (
	[String]$Restart	
 )

If ($Restart -ne "") 
	{
		sleep 10
	} 

$Current_Folder = split-path $MyInvocation.MyCommand.Path
	
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  	 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 	 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') 		 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | out-null
[System.Reflection.Assembly]::LoadFrom("$Current_Folder\assembly\MahApps.Metro.dll") | out-null

$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\mmc.exe")	


# ----------------------------------------------------
# Part - User GUI
# ----------------------------------------------------

[xml]$XAML_Users =  
@"
<Controls:MetroWindow 
	xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	xmlns:i="http://schemas.microsoft.com/expression/2010/interactivity"		
	xmlns:Controls="clr-namespace:MahApps.Metro.Controls;assembly=MahApps.Metro"
	Title="User part" Width="470" ResizeMode="NoResize" Height="300" 
	BorderBrush="DodgerBlue" BorderThickness="0.5" WindowStartupLocation ="CenterScreen">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
				<ResourceDictionary Source="$Current_Folder\resources\Icons.xaml" /> 
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Cobalt.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

   <Controls:MetroWindow.LeftWindowCommands>
        <Controls:WindowCommands>
            <Button>
                <StackPanel Orientation="Horizontal">
                    <Rectangle Width="15" Height="15" Fill="{Binding RelativeSource={RelativeSource AncestorType=Button}, Path=Foreground}">
                        <Rectangle.OpacityMask>
                            <VisualBrush Stretch="Fill" Visual="{StaticResource appbar_user}" />							
                        </Rectangle.OpacityMask>
                    </Rectangle>					
                </StackPanel>
            </Button>				
        </Controls:WindowCommands>	
    </Controls:MetroWindow.LeftWindowCommands>		

    <Grid>	
    </Grid>
</Controls:MetroWindow>        
"@
$Users_Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $XAML_Users))

# Selection Part
$MyControl = $Users_Window.findname("MyControl") 






# ----------------------------------------------------
# Part - User GUI
# ----------------------------------------------------

[xml]$XAML_Computers =  
@"
<Controls:MetroWindow 
	xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	xmlns:i="http://schemas.microsoft.com/expression/2010/interactivity"		
	xmlns:Controls="clr-namespace:MahApps.Metro.Controls;assembly=MahApps.Metro"
	Title="Computers part" Width="470" ResizeMode="NoResize" Height="300" 
	BorderBrush="DodgerBlue" BorderThickness="0.5" WindowStartupLocation ="CenterScreen">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
				<ResourceDictionary Source="$Current_Folder\resources\Icons.xaml" /> 
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Cobalt.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

   <Controls:MetroWindow.LeftWindowCommands>
        <Controls:WindowCommands>
            <Button>
                <StackPanel Orientation="Horizontal">
                    <Rectangle Width="15" Height="15" Fill="{Binding RelativeSource={RelativeSource AncestorType=Button}, Path=Foreground}">
                        <Rectangle.OpacityMask>
                            <VisualBrush Stretch="Fill" Visual="{StaticResource appbar_user}" />							
                        </Rectangle.OpacityMask>
                    </Rectangle>					
                </StackPanel>
            </Button>				
        </Controls:WindowCommands>	
    </Controls:MetroWindow.LeftWindowCommands>		

    <Grid>	
    </Grid>
</Controls:MetroWindow>        
"@
$Computers_Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $XAML_Computers))

# Selection Part
$MyControl = $Computers_Window.findname("MyControl") 









################################################################################################################################"
# ACTIONS FROM THE SYSTRAY
################################################################################################################################"

# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------		
	
$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Main_Tool_Icon.Text = "WPF Systray tool"
$Main_Tool_Icon.Icon = $icon
$Main_Tool_Icon.Visible = $true

$Menu_Users = New-Object System.Windows.Forms.MenuItem
$Menu_Users.Text = "User analysis"

$Menu_Computers = New-Object System.Windows.Forms.MenuItem
$Menu_Computers.Text = "Computer analysis"

$Menu_Restart_Tool = New-Object System.Windows.Forms.MenuItem
$Menu_Restart_Tool.Text = "Restart the tool (in 10secs)"

$Menu_Exit = New-Object System.Windows.Forms.MenuItem
$Menu_Exit.Text = "Exit"

$contextmenu = New-Object System.Windows.Forms.ContextMenu
$Main_Tool_Icon.ContextMenu = $contextmenu
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Users)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Computers)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Restart_Tool)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)








# ---------------------------------------------------------------------
# Action when after a click on the systray icon
# ---------------------------------------------------------------------
$Main_Tool_Icon.Add_Click({					
	[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($Users_Window)
	If ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
		$Users_Window.WindowStartupLocation = "CenterScreen"	
		$Users_Window.Show()
		$Users_Window.Activate()	
	}				
})



# ---------------------------------------------------------------------
# Action after clicking on User Analysis
# ---------------------------------------------------------------------
$Menu_Users.Add_Click({	
	$Users_Window.WindowStartupLocation = "CenterScreen"	
	[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($Users_Window)
	$Users_Window.ShowDialog()
	$Users_Window.Activate()	
})


# ---------------------------------------------------------------------
# Action after clicking on Computer Analysis
# ---------------------------------------------------------------------
$Menu_Computers.Add_Click({
	[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($Computers_Window)
	$Computers_Window.Show()
	$Computers_Window.Activate()	
})




# ---------------------------------------------------------------------
# Action after clicking on the User GUI
# ---------------------------------------------------------------------

$Users_Window.Add_MouseDoubleClick({
})

$Users_Window.Add_MouseLeftButtonDown({
})



# Close the window if it loses focus
$Users_Window.Add_Deactivated({
	$Users_Window.Hide()	
	$CustomDialog.RequestCloseAsync()
	# Close_modal_progress	
})

$Computers_Window.Add_Deactivated({
	$Computers_Window.Hide()
})







# Action on the close button
$Users_Window.Add_Closing({
	$_.Cancel = $true
	[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Users_Window, "Oops :-(", "To close the window click out of the window !!!")					
})

# ---------------------------------------------------------------------
# Action on close computer GUI
# ---------------------------------------------------------------------

$Computers_Window.Add_Closing({
	$_.Cancel = $true
	[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Computers_Window, "Oops :-(", "To close the window click out of the window !!!")					
})








# When Exit is clicked, close everything and kill the PowerShell process
$Menu_Exit.add_Click({
	$Main_Tool_Icon.Visible = $false
	$window.Close()
	Stop-Process $pid
 })

 
 
 # When Exit is clicked, close everything and kill the PowerShell process
$Menu_Restart_Tool.add_Click({
	$Restart = "Yes"
	start-process -WindowStyle hidden powershell.exe "C:\ProgramData\MySystrayTool\PS1_Systray_Tool.ps1 '$Restart'" 	

	$Main_Tool_Icon.Visible = $false
	$window.Close()
	Stop-Process $pid	
 })
 
 
 
 
 
 
 
 
 
 
 

# Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()


# Create an application context for it to all run within.
# This helps with responsiveness, especially when clicking Exit.
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)