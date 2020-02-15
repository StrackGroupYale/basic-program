import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from fpdf import FPDF
import itertools
import numpy as np
import PyPDF2
import data_presentation
##Writing allocation data
def con_df(distributions,types,utilities): #construct dataframe with relevant data
    dist_df = pd.read_csv(distributions,header=None)
    type_df = pd.read_csv(types,header=None)
    ut_df = pd.read_csv(utilities,header=None)

    #create column names
    type_names = []
    for i in range(0,len(type_df.columns)):
        type_names.append(f'Shock for School {i+1}')
    type_df.columns = type_names

    ut_names = []
    for i in range(0, len(ut_df.columns)):
        ut_names.append(f'Utility from School {i + 1}')
    ut_df.columns = ut_names

    dist_names = []
    for i in range(0, len(dist_df.columns)):
        dist_names.append(f'Allocation for School {i + 1}')
    dist_df.columns = dist_names
    df = pd.concat([type_df,ut_df], axis=1)
    df2 = dist_df
    return df2,df

def write_table(df,title):
    fig = plt.figure(facecolor='w', edgecolor='k')
    sns.heatmap(df,annot=True, cmap='viridis',square=False).set_title(f"{title}")
    plt.xticks(fontsize = 4,rotation=0)
    path = f'solver/assignment_data/{title}.png'
    plt.savefig(path)
    return path


if __name__ == "__main__":
    #print(data_presentation.primes(2))
    df2,df = con_df('solver/assignment_data/a_data@2,9.csv','solver/assignment_data/rt_data@2,9.csv','solver/assignment_data/t_data@2,9.csv')
    allocs = write_table(df2,"allocations")
    types = write_table(df,"types")
    sp = data_presentation.placements_cw(2)
    data_presentation.concat_page(sp,'better_version','solver/assignment_data/allocations.png','solver/assignment_data/types.png')
