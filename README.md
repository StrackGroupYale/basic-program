# Social Welfare Solver 
This solver is intended to find allocations which are solutions to the following optimization regime:
<p style="text-align: center;"> 
<a href="https://www.codecogs.com/eqnedit.php?latex=\max_{m_{\theta&space;a}}&space;\sum_{\theta&space;\in&space;\Theta}f_{\theta}\sum_{a&space;\in&space;A}&space;u_{\theta&space;a}m_{\theta&space;a}&space;\text{&space;s.t.&space;}" target="_blank"><img src="https://latex.codecogs.com/png.latex?\max_{m_{\theta&space;a}}&space;\sum_{\theta&space;\in&space;\Theta}f_{\theta}\sum_{a&space;\in&space;A}&space;u_{\theta&space;a}m_{\theta&space;a}&space;\text{&space;s.t.&space;}" title="\max_{m_{\theta a}} \sum_{\theta \in \Theta}f_{\theta}\sum_{a \in A} u_{\theta a}m_{\theta a} \text{ s.t. }" /></a>
</p>

<p style="text-align: center;"> 
<a href="https://www.codecogs.com/eqnedit.php?latex=\sum_{a&space;\in&space;A}&space;u_{\theta&space;a}&space;m_{\theta&space;a}&space;-&space;\sum_{a&space;\in&space;A}&space;u_{\theta&space;a}&space;m_{\theta&space;'&space;a}&space;\geq&space;0" target="_blank"><img src="https://latex.codecogs.com/png.latex?\sum_{a&space;\in&space;A}&space;u_{\theta&space;a}&space;m_{\theta&space;a}&space;-&space;\sum_{a&space;\in&space;A}&space;u_{\theta&space;a}&space;m_{\theta&space;'&space;a}&space;\geq&space;0" title="\sum_{a \in A} u_{\theta a} m_{\theta a} - \sum_{a \in A} u_{\theta a} m_{\theta ' a} \geq 0" /></a>
</p>

<p style="text-align: center;">
<a href="https://www.codecogs.com/eqnedit.php?latex=\sum_{\theta&space;\in&space;\Theta}&space;f_{\theta}&space;m_{\theta&space;a}&space;\leq&space;c_a,&space;\forall&space;a" target="_blank"><img src="https://latex.codecogs.com/png.latex?\sum_{\theta&space;\in&space;\Theta}&space;f_{\theta}&space;m_{\theta&space;a}&space;\leq&space;c_a,&space;\forall&space;a" title="\sum_{\theta \in \Theta} f_{\theta} m_{\theta a} \leq c_a, \forall a" /></a>
</p>
<p style="text-align: center;"> 
<a href="https://www.codecogs.com/eqnedit.php?latex=\sum_{a&space;\in&space;A}&space;m_{\theta&space;a}&space;\leq&space;1,&space;\forall&space;\theta&space;\in&space;\Theta" target="_blank"><img src="https://latex.codecogs.com/png.latex?\sum_{a&space;\in&space;A}&space;m_{\theta&space;a}&space;\leq&space;1,&space;\forall&space;\theta&space;\in&space;\Theta" title="\sum_{a \in A} m_{\theta a} \leq 1, \forall \theta \in \Theta" /></a>
</p>
<p style="text-align: center;"> 
<a href="https://www.codecogs.com/eqnedit.php?latex=m_{\theta&space;a}&space;\geq&space;0,&space;\forall&space;\theta,&space;\forall&space;a" target="_blank"><img src="https://latex.codecogs.com/png.latex?m_{\theta&space;a}&space;\geq&space;0,&space;\forall&space;\theta,&space;\forall&space;a" title="m_{\theta a} \geq 0, \forall \theta, \forall a" /></a>
</p>


 
