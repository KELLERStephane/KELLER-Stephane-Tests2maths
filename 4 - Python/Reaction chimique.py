import matplotlib.pyplot as plt #création d’un alias

plt.clf() #efface la figure
#n_di : quantité de matière de diode en mol
#n_tri : quantité de matière de triosulfate en mol
#n_tetra : quantité de matière de tétrationate en mol
#n_iod : quantité de matière initiale2 en mol

def Evol_Qt(n_di, n_tri, n_tetra, n_iod):
    x, dx = 0, 0.001
    li_x = [x]
    li_di = [n_di]
    li_tri = [n_tri]
    li_tetra = [n_tetra]   
    li_iod = [n_iod]
    
    while li_di[-1] > 0 and li_tri[-1] > 0:
        x += dx
        li_x.append(x)
        li_di.append(n_di - x)
        li_tri.append(n_tri - 2 * x)
        li_tetra.append(n_tetra + x)
        li_iod.append(n_iod + 2 * x)
        
    plt.title("Evolution des quantités de matière \nen fonction de l'avancement de la réaction ")
    plt.plot(li_x,li_di, 'r-', label = "n I\u2082 en mol")
    plt.plot(li_x,li_tri, 'b-', label = "n S\u2082O\u2083 en mol")
    plt.plot(li_x,li_tetra, 'g-', label = "n S\u2084O\u2086 en mol")
    plt.plot(li_x,li_iod, 'y-', label = "n I en mol")
    plt.grid()
    plt.legend()
    plt.xlabel("x (mol)")
    plt.ylabel("n (mol)")
    plt.show()

Evol_Qt(1, 3, 0, 0)

Evol_Qt(2, 3, 0, 0)

Evol_Qt(2, 4, 0, 0)
    
        
