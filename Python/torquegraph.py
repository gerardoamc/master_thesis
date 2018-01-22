# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 14:47:55 2017

@author: lvanhulle
"""

# Program to convert torque csv data into something useful

import os
import re
from collections import namedtuple as nt
import numpy as np
from matplotlib import pyplot as plt

path = 'C:\\Users\\lvanhulle\\Box Sync\\Otto\\Torsion Test Data'

testnum = r"(\d+\.?\d?)"

TIME = 'time'
TORQUE = 'torque'
ANGLE = 'angle'

fileNames = os.listdir(path)
filesList = []

ID = nt('ID', 'number name')

files = {}

figNum = 1

for name in fileNames:
    number = float(re.search(testnum, name).group())
    files[number] = name
    #print(number)

def updateFilesList():   
    global filesList
    filesList = [ID(key,value) for key,value in files.items()]

updateFilesList()
print(*filesList, sep='\n')

def formData(testNumber):
    fileName = path + '\\' + files[testNumber]
    array = np.genfromtxt(fileName, skip_header=3, usecols = (0,1,4),
                          delimiter=',', dtype='float', names = ['time', 'torque', 'angle'])
    array[TORQUE] *= 0.11298 # Convert lb-in to N-m
    return array

def graphTorquevsAngle(testNumber):
    data = formData(testNumber)
    plt.figure(testNumber)
    plt.plot(data[ANGLE], data[TORQUE])
    plt.xlabel('Angle (deg)')
    plt.ylabel('Torque (N-m)')
    plt.title('Torque vs Angle for Test #' + str(testNumber))
    
def graphMultiple(*args, maxAngle=150):
    global figNum
    plt.figure(figNum)
    figNum += 1
    plt.xlabel('Angle (deg)')
    plt.ylabel('Torque (N-m)')
    plt.title('Torque vs Angle for Tests ' + str(args))
    
    for testNumber in args:
        data = formData(testNumber)
        mask = data[ANGLE] < maxAngle
        plt.plot(data[ANGLE][mask], data[TORQUE][mask], label=str(testNumber))
        
    plt.legend(loc=9, bbox_to_anchor=(0.5,-.11), ncol=4)

def correctedMultiGraph(*args, maxAngle=60, matchTorque=7, dip=0.2, name='data1.txt'):
    global figNum
    figNum += 1
    plt.figure(figNum)    
    plt.xlabel('Angle (deg)')
    plt.ylabel('Torque (N-m)')
    plt.title('Torque vs Angle for Tests ' + str(args))
    
    datas = []
    for testNumber in args:
        data = formData(testNumber)
        mask = data[ANGLE] < maxAngle
        data = data[mask]
        
        mask = data[TORQUE] > matchTorque
        data = data[mask]
        data[ANGLE] -= data[ANGLE][0]
        
        yieldT = yieldTorque(testNumber)
        mask = np.logical_or(data[ANGLE] < 20, data[TORQUE] > (1-dip)*yieldT)
        data = data[mask]
        
        mask = np.array([False if x%6 else True for x in range(len(data))])
        data = data[mask]
        print(len(data), len(data[ANGLE]))
        plt.plot(data[ANGLE], data[TORQUE], label=str(testNumber))
        datas.append(data[ANGLE])
        datas.append(data[TORQUE])
    plt.legend(loc=9, bbox_to_anchor=(0.5,-.11), ncol=4)
    
    writeData(args, datas, name)
    
def writeData(args, data, fileName):
    with open(fileName, 'w') as f:
        for num in args:
            f.write('Angle'+str(num)+'\tTor'+str(num) + '\t')
        f.write('\n')
        length = max(len(x) for x in data)
        for i in range(length):
            for d in data:
                try:
                    f.write(str(d[i]))
                except Exception:
                    f.write('nan')
                f.write('\t')
            f.write('\n')
        

def yieldTorque(testNumber, dip=0.05, minAngle=2):
    data = formData(testNumber)
    torque = data[TORQUE][data[ANGLE] > minAngle]
    yieldTorque = 0
    for tor in torque:
        if tor > yieldTorque:
            yieldTorque = tor
        elif tor < yieldTorque*(1-dip):
            return yieldTorque
        
        
def errorBars(*args, matchTorque=7, maxAngle=60, dip=0.05):
    datas = []
    for testNumber in args:
        data = formData(testNumber)
        mask = data[TORQUE] > matchTorque
        data = data[mask]
        data[ANGLE] -= data[ANGLE][0]
        datas.append(data)
    minLen = min(len(x) for x in datas)
    print(minLen)
    avgTorque = np.zeros(minLen)
    for data in datas:
        avgTorque += data[TORQUE][:minLen]
    avgTorque /= len(datas)
    avg = (avgTorque, datas[0][ANGLE][:minLen])
    
    std = np.zeros(minLen)
    
    for data in datas:
        diff = data[TORQUE][:minLen] - avgTorque
        std += diff*diff
    std /= len(datas)
    return std, avg
    
        
        

       
        