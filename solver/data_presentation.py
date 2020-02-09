#present data
import pandas as pd
import numpy as np
import subprocess
import os
import matplotlib.pyplot as plt
import seaborn as sns


def con_df(distributions,types):
    dist_df = pd.read_csv(distributions,header=None)
    type_df = pd.read_csv(types,header=None)

    #create column names
    type_names = []
    for i in range(0,len(type_df.columns)):
        type_names.append(f'Shock for School {i+1}')
    type_df.columns = type_names
    dist_names = []
    for i in range(0, len(dist_df.columns)):
        dist_names.append(f'Allocation for School {i + 1}')
    dist_df.columns = dist_names
    df = pd.concat([dist_df,type_df], axis=1)

    return df
def write_table(df):
    fig = plt.figure(facecolor='w', edgecolor='k')
    sns.heatmap(df,annot=True, cmap='viridis',square=False)
    plt.xticks(fontsize = 6,rotation=0)
    plt.savefig('assignment_data/DataFrame.png')


if __name__ == "__main__":
    #print(os.getcwd())
    df = con_df('assignment_data/a_data@2,9.csv','assignment_data/rt_data@2,9.csv')
    print(df)
    write_table(df)
    #
