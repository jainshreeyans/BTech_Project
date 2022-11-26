%Flash sintering elmer data calculation
clc;
m=load('/Users/jainshreeyans/BTP/Flash_test_15-12_8wt%_CAS.txt');

t=m(:,1);%time of the experimnet in second
v=m(:,2);%voltage in volt
i=m(:,3);%current in A

power=v.*i;%power in W

density =6050;% density of sample kg/m3
dia=6e-3;%dia of sample in m
h=6e-3;%height of sample in m
a=3.14*((dia/2.0)^2);% cross-sectional area of sample

cd=i/a;%current density
E=v/h;%Electric field
sigma=cd./E;%conductivity

ln_sigma=log(sigma);

dia_inconel=20e-3;%dia of inconel in m
h_inconel=3e-3;%height of inconel in m


vs=3.14*((dia/2.0)^2)*h; % volume of the sampl in m3
power_m=power/(vs*density);%power per unit mass in W/kg

R_inconel=1.31*10^(-6); %Resitivity of inconel at 900C in ohm-m
density_inconel =8113;% density of inconel kg/m3

joule_inconel=i.*i*R_inconel*h_inconel/(3.14*(dia_inconel/2.0)^2); % Joule heating in inconel in W

joule_inconel_m=joule_inconel/(h_inconel*(3.14*(dia_inconel/2.0)^2)*density_inconel);% Joule heating per unit mass in inconel in W/kg

Eg=8.9127; % Energy to create oxygen vacacy in zirconia in ev/atom
vac_gen_heat=-i*Eg/2;%Vacancy Generation Heat in W


h_thin=0.1*10^(-3); %height of thin electrode region
v_thin=3.14*((dia/2.0)^2)*h_thin; % volume of thin electrode region

vac_gen_heat_m=vac_gen_heat/(v_thin*density);%Vacancy Generation heat per unit mass Heat in W/kg

vac_ann_heat_m=-1.0*vac_gen_heat/(v_thin*density);%Vacancy annihilation heat per unit mass Heat in W/kg

near_cathode_heat_m=vac_ann_heat_m+power_m; % Near cathode heat geneartion
near_anode_heat_m=vac_gen_heat_m+power_m; % Near anode heat geneartion

fid=fopen('Joule_Heat_in_CAS_8wt%.txt','w');
increment=4;
for j=1:increment:length(t)
    
fprintf(fid, '%f\t%f\n', t(j),power_m(j));
   
end
fid1=fopen('Joule_Heat_in_Inconel.txt','w');

for j=1:increment:length(t)
    
fprintf(fid1, '%f\t%f\n', t(j),joule_inconel_m(j));
   
end
fid2=fopen('Heat_Near_Anode.txt','w');

for j=1:increment:length(t)
    
fprintf(fid2, '%f\t%f\n', t(j),near_anode_heat_m(j));
   
end
fid3=fopen('Heat_Near_Cathode.txt','w');

for j=1:increment:length(t)
    
fprintf(fid3, '%f\t%f\n', t(j),near_cathode_heat_m(j));
   
end

fid4=fopen('Sigma_Vs_t.txt','w');

for j=1:increment:length(t)
  
fprintf(fid4,'%f\t%f\t%f\n', t(j),sigma(j),ln_sigma(j));
    
end
plot(t, power_m, t, joule_inconel_m, t, vac_gen_heat_m, t, vac_ann_heat_m,  t,near_cathode_heat_m, t,near_anode_heat_m)
xlabel('Time(second)')
ylabel('Power per unit mass(W/Kg)')
legend('Joule Heating in 8wt% CAS', 'Joule heating in inconel', 'Vacancy generation heat','Vacancy annihilation Heat','Near Cathode Heat', 'Near Anode Heat','Location','NorthWest')
print -djpeg -r600 FS_P_vs_time

fclose('all');
