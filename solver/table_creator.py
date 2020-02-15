import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from fpdf import FPDF
import itertools
import numpy as np
import PyPDF2
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
    df = pd.concat([dist_df,type_df,ut_df], axis=1)

    return df

def write_table(df,title):
    fig = plt.figure(facecolor='w', edgecolor='k')
    sns.heatmap(df,annot=True, cmap='viridis',square=False).set_title(f"{title}")
    plt.xticks(fontsize = 4,rotation=0)
    path = f'solver/assignment_data/{title}.png'
    plt.savefig(path)
    return path

def bin_it(df):
    

   #want to write types which get assignment for each school
if __name__ == "__main__":
    df = con_df('solver/assignment_data/a_data@2,9.csv','solver/assignment_data/rt_data@2,9.csv','solver/assignment_data/t_data@2,9.csv')
    table = write_table(df,"allocations")