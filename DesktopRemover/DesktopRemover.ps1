###

function Screenshot {
    $Y =($env:tmp);
    $Date =((get-date).ToString('yyMMddHHmmss'));
    $global:Name = "Screenshot" + $Date;
    Add-Type -AssemblyName *m.*s.F*s;
    Add-type -AssemblyName *m.Dr*g;
    $S = [System.Windows.Forms.Screen]::PrimaryScreen;
    $W = $S.WorkingArea.Width;
    $H = $S.Bounds.Height;
    $F = $S.WorkingArea.Left;
    $T = $S.WorkingArea.Top;
    $B = New-Object System.Drawing.Bitmap $W, $H;
    $G = [System.Drawing.Graphics]::FromImage($B);
    $G.CopyFromScreen($F, $T, 0, 0, $B.Size);
    $B.Save($Y+"\" +$Name + ".png");Start-Sleep 3;
    $global:Path = ($Y + "\" +$Name + ".png");
    }

###

function SetWallpaper{

$setwallpapersrc = @"
using System.Runtime.InteropServices;
public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setwallpapersrc

[Wallpaper]::SetWallpaper($Path)
}

###
Screenshot;
SetWallpaper;

$Hide="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $Hide -Name "HideIcons" -Value 1
Get-Process "explorer"| Stop-Process