using CSV

function plot(a_file,t_file)
    a_df = CSV.read(a_file,header=0)
    t_df = CSV.read(t_file,header=0)
end

plot("solver/assignment_data/a_data@2,9.csv","solver/assignment_data/t_data@2,9.csv")
