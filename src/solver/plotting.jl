using Plots
using CSV
module plotting
    export plot_performance
    function plot_performance(shocks,utilities)
        df = CSV.read("solver/test_data/time@$shocks,$utilities.csv")
        x = df[!,:types]
        y = df[!,:time]
        plot(x,y,title="Time to Solve Over Number of Types")
        xlabel!("Number of Types")
        ylabel!("Seconds")
        savefig(f"solver/test_data/time_vs_complexity@$shocks,$utilities.png")
    end
    function plot_welfare()
    end
end