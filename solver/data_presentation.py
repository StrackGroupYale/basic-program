#present data
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from fpdf import FPDF
import itertools
import numpy as np
#import PIL
#from PIL import Image

##Image Processing
def primes(n): #borrowed
    primes = []
    i = 2
    m = n
    while i < n+1:
        while m % i == 0:
            m = m / i
            #print(m)
            primes.append(i)
        i = i + 1
    if (primes == []):
        primes = [n]
    return primes

def placements_cw(partition_size):
    #total size of page is 205 x 295
    if (partition_size % 2 == 0):
        template_size = partition_size
    if (partition_size % 2 != 0):
        template_size = partition_size + 1

    #UPF
    #print('template_size',template_size)
    UPF = primes(template_size)
    UPF_len = int(len(UPF))
    #print('UPF',UPF)
    ##randomly partition, find best split
    l = list(itertools.permutations(range(0,int(UPF_len))))
    #print(l)
    num_perms = len(l)
    h = 0
    w = 0
    best = 10**10
    for k in range(0,num_perms):
        permed_UPF = np.zeros(int(UPF_len))
        for m in range(0,len(permed_UPF)):
            permed_UPF[m] = UPF[l[k][m]]
        if (len(permed_UPF) == 1):
            h = 1
            w = 2
        
        for p in range(1,len(permed_UPF)): #used to not have -1
            cand_h = np.prod(permed_UPF[:p])
            cand_w = np.prod(permed_UPF[p:]) #used to not have 1
            error = abs(cand_h/cand_w - 3/2)
            #print(cand_h, cand_w)
            if(error < best):
                best = error
                h = int(cand_h)
                w = int(cand_w)
    size_pos = []
    #print('h,w',h,w)
    #for i in range(0,partition_size):
    size = [200/w,290/h]

    for k in range(0,h):
        for j in range(0,w):
            #b = [int(size[0]+i*size[0]),int(size[1]+k*size[1]),int(size[0]/2),int(size[1]/2)]
            b = [j * size[0],k * size[1], int(size[0]), int(size[1])]
            #print(size[0])
            size_pos.append(b)
    return size_pos

def concat_page(size_pos,pdf_name,*args):
    #to begin, each gets its own page. will edit this
    pdf = FPDF()
    index = 0
    pdf.add_page()
    for i in args:
        x = int(size_pos[index][0])
        y = int(size_pos[index][1])
        w = int(size_pos[index][2])
        h = int(size_pos[index][3])
        #print(x,y,w,h)
        pdf.image(i,x,y,w,h)
        index = index + 1
        print(index)
    pdf.output(f"solver/assignment_data/{pdf_name}.pdf","F")

def concat_pdfs(pdf_path,*args):
    merge = PyPDF2.PdfFileMerger()
    for i in args:
        merge.append(i)
    merge.write(f"{pdf_path}.pdf")
    merge.close()

if __name__ == "__main__":
    2+2
    #spots = placements_cw(11)
    #concat_page(spots,'11_tables',table,table,table,table,table,table,table,table,table,table,table)
    #spots = placements_cw(17)
    #concat_page(spots,'17_tables',table,table,table,table,table,table,table,table,table,table,table,table,table,table,table,table,table)
    #concat_pdfs('assignment_data/28_tables.pdf','assignment_data/11_tables.pdf','assignment_data/17_tables.pdf')
