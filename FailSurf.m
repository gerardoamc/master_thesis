%______________________________________________________________
%                      FFF failure surface
%              Developed by Gerardo A. Mazzei Capote
%    Based on findings by T. Osswald, P.V. Osswald and P. Obst
%                           March 2018
%
%Failure Criterion proposed by P.V. Osswald and T.A. Osswald.
%For more information, refer to:
%Journal of Polymer Composites, DOI 10.1002/pc.24275
%The notation here follows the same notation used in this paper
%______________________________________________________________
classdef FailSurf
    methods (Static)
        function [F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212]=tens(Xt,Xc,Yt,Yc,S,S45_p,S45_n,mu1112,mu2212,lambda1122) %Tensorial components calculation
            F_1111=0.25*(1/Xt+1/Xc)^2;
            F_2222=0.25*(1/Yt+1/Yc)^2;
            F_1212=(1/S)^2;
            F_11=0.5*(1/Xt-1/Xc);
            F_22=0.5*(1/Yt-1/Yc);
            F_12=0;
            %Flexibility regarding which slope to use:
            disp('0- Goldenblat-Kopnov, 1- Positive x axis, 2- Positive y axis, 3- Negative x axis, 4- Negative y axis')
            reply = input('Please enter which slope option corresponds to lambda: ');
            if reply == 0
                F_1122=0.125*((1/Xt+1/Xc)^2+(1/Yt+1/Yc)^2-(1/S45_p+1/S45_n)^2); %Per Gol'denblat- Kopnov
            elseif reply == 1
                F_1122=-((F_11+F_22*lambda1122)*F_1111^0.5+F_1111)/lambda1122; %Slope at Intercept of Positive x axis
            elseif reply == 2
                F_1122=-(F_11-F_22*lambda1122)*F_2222^0.5-F_2222*lambda1122; %Slope at Intercept of Positive y axis
            elseif reply == 3
                F_1122=((F_11+F_22*lambda1122)*F_1111^0.5-F_1111)/lambda1122; %Slope at Intercept of Negative x axis
            elseif reply == 4
                F_1122=(F_11+F_22*lambda1122)*F_2222^0.5-F_2222*lambda1122; %Slope at Intercept of Negative y axis
            else
                error('Input must be one of the options listed above. Execution ended.')
            end
            F_1112=-(F_11/S)-F_1212*mu1112;
            F_2212=-(F_22/S)-F_1212*mu2212;
        end
        %%
        function f=criteria(s1,s2,t12,F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212) %Evaluating the failure criteria for stress inputs
            %s1: sigma11, s2: sigma22, t12: tau12
            f=F_11*s1+F_22*s2+F_12*t12+...
                (F_1111*s1.^2+F_2222*s2.^2+2*F_1122*s1.*s2+F_1212*t12.^2+2*F_2212*s2.*abs(t12)+2*F_1112*s1.*abs(t12)).^0.5;
            for x=1:size(f) %Filter any results where f is greater than 1
                if f(x)>1
                    f(x)=1;
                end
            end
        end
        %%
        function g=graph(s1,s2,t12,f,s) %Used to plot the resulting failure surface
            %s: number of equally spaced failure surfaces from 0 to 1
            %e.g. s=5 will generate 4 surfaces: 0.25, 0.5, 0.75 and 1
            if (nargin ==4)
                s= 5;
                disp('Using f from 0 to 1 in increments of 0.25 by default')
            end
            cvals = linspace(0,1,s);
            Sx = [];            Sy = [];            Sz = -70:70;
            g=figure(1); %Create new figure
            contourslice(s1,s2,t12,f,Sx,Sy,Sz,cvals);
            view(3); %View angle
            axis tight; %Set axes
            daspect([1,1,1]); %data aspect ratio of 1:1:1
            box on %encloses all plot
            set(gca,'FontSize',14) %Sets the font size for axes
            hold on
            xlabel('\sigma_{11} [MPa]','fontsize',16)  % x-axis label
            ylabel('\sigma_{22}  [MPa]','fontsize',16)  % y-axis label
            zlabel('\tau_{12}  [MPa]','fontsize',16)  % z-axis label
            %Allow user to save graph
            reply1 = input('Would you like to save this graph? [Y/N]: ', 's');
            if isempty(reply1)
                reply1 = 'N';
                disp('No input. Using "N" as default')
            end
            if (reply1=='Y')
                disp('Available options: -dpdf, -depsc, -dpng, -djpeg')
                reply2= input('Select file type: ', 's');
                if isempty(reply2)
                    reply2 = '-djpeg';
                    disp('No input. Graph saved as jpeg by default.')
                end
                reply3= input('Choose file name :', 's');
                if isempty(reply3)
                    reply3 = 'fig1';
                    disp('No input. Graph named "fig1" by defalut.')
                end
                print(reply3,reply2) %Saves plot in selected file type on the current directory
            elseif (reply1== 'N')
                disp('Graph not saved.')
            else
                error('Input must be one of the options listed above. Execution ended.')                
            end
        end
    end
end