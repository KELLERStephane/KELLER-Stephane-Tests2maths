import subprocess

def runcmd(cmd, verbose = False, *args, **kwargs):

    process = subprocess.Popen(
        cmd,
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE,
        text = True,
        shell = True
    )
    std_out, std_err = process.communicate()
    if verbose:
        print(std_out.strip(), std_err)
    pass

for i in range(30):
    cmd = "sudo wget https://github.com/KELLERStephane/KELLER-Stephane-Tests2maths/blob/master/7%20-%20Raspberry%20Pi/Ressources/lune/lune/"+str(i)+".png"
    runcmd(cmd, verbose = True)
