import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from fpdf import FPDF
import itertools
import numpy as np
import PyPDF2
import data_presentation
import math
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

def write_table(df,title,folder_path):
    fig = plt.figure(facecolor='w', edgecolor='k')
    sns.heatmap(df,annot=True, cmap='viridis',square=False).set_title(f"{title}")
    plt.xticks(fontsize = 4,rotation=0)
    path = f'{folder_path}/{title}.png'
    plt.savefig(path)
    return path

def write_allocs_types_(num_schools,num_types,name,folder_path,gen_utilities_filename):
    size = (num_schools,num_types)
    u_df2,u_df = con_df(f'{folder_path}/a_datainfo_unconstrained@{size[0]},{size[1]}.csv',f'{folder_path}/rt_datainfo_unconstrained@{size[0]},{size[1]}.csv',f'{folder_path}/t_datainfo_unconstrained@{size[0]},{size[1]}.csv')
    u_allocs = write_table(u_df2,"unconstrained_allocations",f'{folder_path}')
    u_types = write_table(u_df,"unconstrained_types",f'{folder_path}')

    c_df2,c_df = con_df(f'{folder_path}/a_datainfo_constrained@{size[0]},{size[1]}.csv',f'{folder_path}/rt_datainfo_constrained@{size[0]},{size[1]}.csv',f'{folder_path}/t_datainfo_constrained@{size[0]},{size[1]}.csv')
    c_allocs = write_table(c_df2,"constrained_allocations",f'{folder_path}')
    c_types = write_table(c_df,"constrained_types",f'{folder_path}')

    #find constrained and unconstrained utilities
    u_utilities_df = pd.read_csv(f"{folder_path}/{gen_utilities_filename}infounconstrained@{size[0]},{size[1]}.csv")
    c_utilities_df = pd.read_csv(f"{folder_path}/{gen_utilities_filename}infoconstrained@{size[0]},{size[1]}.csv")
    #print(u_utilities_df)
    u_tot = u_utilities_df["Total"][1]
    c_tot = c_utilities_df["Total"][1]
    u_utilities = write_table(pd.DataFrame(u_utilities_df["Indiv"]),f"Unconstrained_Utilities@Total={u_tot}",f'{folder_path}')
    c_utilities = write_table(pd.DataFrame(c_utilities_df["Indiv"]),f"Constrained_Utilities@Total={c_tot}",f'{folder_path}')
    
    
    approx_proportion = approx_proportion = int(math.floor(size[1]/size[0])) # initialized for 2,9 -> 4
    sp = data_presentation.placements_cw(2*approx_proportion)
    data_presentation.concat_page(sp,f"{name}@total_(un)constrained_utility={c_tot},({u_tot})",f"{folder_path}/constrained_allocations.png",f"{folder_path}/constrained_types.png",f"{folder_path}/unconstrained_allocations.png",f"{folder_path}/unconstrained_types.png",f"{folder_path}/Constrained_Utilities@Total={c_tot}.png",f"{folder_path}/Unconstrained_Utilities@Total={u_tot}.png")

    return f'{folder_path}/{name}.pdf'

if __name__ == "__main__":
    #write_allocs_types_(2,9,'Allocation_Info','solver/assignment_data','a_data:')
    write_allocs_types_(2, 9, 'Allocation_Info', 'solver/2x3_example/assign_data', 'a_data:')

