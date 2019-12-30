###the marginal likelihood is N(0,\sigma_[0] + \sigma^2)


post_mean=function(priormean,priorsd,datamean,datase){
priorsd^2/(datase^2+priorsd^2)*datamean+datase^2/(datase^2+priorsd^2)*priormean}

post_var=function(priorsd,datase){
1/(1/datase^2+1/priorsd^2)}

###Here, we create a funbciton for the posterior weights as p(K|D)=p(D|K)*p(K)/sum_k[p(D|K)*p(K)] where p(K)= 1-pi0 for chosen level of skepticism
pipost=function(pi1,dataSE,datamean,priorsd){
sdlik=sqrt(priorsd^2+dataSE^2)
pi0=1-pi1
joint=pi1*dnorm(datamean,mean = 0,sd=sdlik)
marginal=pi1*dnorm(datamean,mean = 0,sd=sdlik)+pi0*dnorm(datamean,mean = 0,sd=dataSE)
pip=joint/marginal
return(pip)}

# set.seed(123)
# pi0s=seq(0.01,1,by=0.05)##proportional weight on slab (non0 component)
# pis=1-pi0s
# #pis=seq(0,1,by=0.01)
# dse=0.21
# dm=-0.44
# priorsd=0.75
# sim=10000
# 
# runpisim=function(dm,priorsd,dse,priome){
# simmat=matrix(NA,ncol=length(pis),nrow=sim)
# for(i in 1:length(pis)){
# p1=pis[i]
# p=pipost(p1,dataSE=dse,datamean=dm,priorsd=priorsd)###computer posterior weight on nonzero component using chosen prior weight
# s=rbinom(1,n = sim,prob=p)##create a list indexing whether comes from null or real depending on posterior weight, where for each simulation, an RV (0,1) is simulated from Binomial(n=1,size=1) according to posterio weight
# pm=sapply(s,function(s){post_mean(priormean=0,priorsd=s*1,datamean=dm,datase=dse)})##depending on whether null or alternative chosen, simulate posterior mean of distribution
# ps=sqrt(sapply(s,function(s){post_var(priorsd=s*1,datase=dse)}))##depending on whether null or alternative chosen, simulate posterior mean of distribution
# b=sapply(seq(1:length(pm)),function(x){rnorm(1,mean = pm[x],sd=ps[x])})##for each simulation choose a rv according to simulated mean and variance
# simmat[,i]=b
# }
# return(simmat)}




