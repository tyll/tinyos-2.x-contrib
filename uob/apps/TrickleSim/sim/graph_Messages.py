#!/usr/bin/python

import matplotlib
import matplotlib.pyplot as plt

import numpy as np

K = 0
#K = 1
#K = 2

if K == 1:
# #messages for k=1, trickle, 300s after inject
    nodes_5_5 = [76, 37, 25, 16, 12, 8]
    nodes_10_10 = [313, 130, 68, 49, 33, 27]
    nodes_20_20 = [1212, 428, 226, 156, 100, 77]

if K == 2:
# #messages for k=2, trickle, 300s after inject
    nodes_5_5 = [102, 60, 41, 29, 19, 15]
    nodes_10_10 = [389, 206, 119, 86, 59, 50]
    nodes_20_20 = [1465, 720, 401, 266, 178, 137]

if K == 0:
# #messages for k=0, PUSH, 300s after inject
    nodes_5_5 = [175, 175, 175, 175, 175, 175]
    nodes_10_10 = [700, 700, 700, 700, 700, 700]
    nodes_20_20 = [2800, 2800, 2800, 2800, 2800, 2800]

factor = K*1.5

# #cycles with tau_l = 2 tau_h = 128
C = 7.36

conn = [1, 2, 3, 4, 5, 6]
neighbors = [4., 12., 28., 48., 80., 112.]
inv_neighbors = [ 1/x for x in neighbors]

neighbors_all = range(1, 120, 1)

nodes_5_5_fit   = np.polyfit(inv_neighbors, nodes_5_5, 1)
nodes_10_10_fit = np.polyfit(inv_neighbors, nodes_10_10, 1)
nodes_20_20_fit = np.polyfit(inv_neighbors, nodes_20_20, 1)

print nodes_5_5_fit
print nodes_10_10_fit
print nodes_20_20_fit

print " 5x5: messages: y=", str(nodes_5_5_fit[0] )  + "*x+"+ str(nodes_5_5_fit[1])
print "10x10: messages: y=", str(nodes_10_10_fit[0]) + "*x+"+ str(nodes_10_10_fit[1])
print "20x20: messages: y=", str(nodes_20_20_fit[0]) + "*x+"+ str(nodes_20_20_fit[1])

nodes_5_5_poly   = np.poly1d(nodes_5_5_fit)
nodes_10_10_poly = np.poly1d(nodes_10_10_fit)
nodes_20_20_poly = np.poly1d(nodes_20_20_fit)

xp = np.linspace(inv_neighbors[-1], inv_neighbors[0], 2)

nodes_5_5_model   = np.array([ 5**2 * factor*C,  5*factor])
nodes_10_10_model = np.array([10**2 * factor*C, 10*factor])
nodes_20_20_model = np.array([20**2 * factor*C, 20*factor])

print nodes_5_5_model
print nodes_10_10_model
print nodes_20_20_model

nodes_5_5_poly_model   = np.poly1d(nodes_5_5_model)
nodes_10_10_poly_model = np.poly1d(nodes_10_10_model)
nodes_20_20_poly_model = np.poly1d(nodes_20_20_model)

#################
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111)

plt.title('#Messages vs Connectivity')
plt.xlabel("Connectivity")
plt.ylabel("# Messages")

plt.plot(conn, nodes_5_5,   marker='.', ls='None', markerfacecolor='r', markeredgecolor='None', markersize=10, label=' 5x5 simulated')
plt.plot(conn, nodes_10_10, marker='.', ls='None', markerfacecolor='g', markeredgecolor='None', markersize=10, label='10x10 simulated')
plt.plot(conn, nodes_20_20, marker='.', ls='None', markerfacecolor='b', markeredgecolor='None', markersize=10, label='20x20 simulated')

plt.xlim(conn[0]-1, conn[-1]+1)
plt.ylim(0, 3000)

plt.legend()

plt.text(.5, .9,
          "K: " + str(K),
          horizontalalignment='center',
          verticalalignment='center',
          transform = ax.transAxes,
          bbox=dict(facecolor='red', alpha=0.2))
plt.savefig("sim/msg_conn_k"+str(K)+".png")

#################
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111)

plt.title('#Messages vs #Neighbors')
plt.xlabel("#Neighbors")
plt.ylabel("# Messages")

plt.plot(neighbors, nodes_5_5,   marker='.', ls='None', markerfacecolor='r', markeredgecolor='None', markersize=10, label=' 5x5 simulated')
plt.plot(neighbors, nodes_10_10, marker='.', ls='None', markerfacecolor='g', markeredgecolor='None', markersize=10, label='10x10 simulated')
plt.plot(neighbors, nodes_20_20, marker='.', ls='None', markerfacecolor='b', markeredgecolor='None', markersize=10, label='20x20 simulated')

nodes_5_5_poly_inv   = [ (nodes_5_5_fit[0]   * 1/x + nodes_5_5_fit[1])   for x in neighbors_all ]
nodes_10_10_poly_inv = [ (nodes_10_10_fit[0] * 1/x + nodes_10_10_fit[1]) for x in neighbors_all ]
nodes_20_20_poly_inv = [ (nodes_20_20_fit[0] * 1/x + nodes_20_20_fit[1]) for x in neighbors_all ]

plt.plot(neighbors_all, nodes_5_5_poly_inv,   ls=':', color='r', label=' 5x5 linear fit')
plt.plot(neighbors_all, nodes_10_10_poly_inv, ls=':', color='g', label='10x10 linear fit')
plt.plot(neighbors_all, nodes_20_20_poly_inv, ls=':', color='b', label='20x20 linear fit')

nodes_5_5_poly_model_inv   = [ (nodes_5_5_model[0]   * 1/x + nodes_5_5_model[1])   for x in neighbors_all ]
nodes_10_10_poly_model_inv = [ (nodes_10_10_model[0] * 1/x + nodes_10_10_model[1]) for x in neighbors_all ]
nodes_20_20_poly_model_inv = [ (nodes_20_20_model[0] * 1/x + nodes_20_20_model[1]) for x in neighbors_all ]

#print nodes_5_5_poly_model_inv
#print nodes_10_10_poly_model_inv
#print nodes_20_20_poly_model_inv

if K != 0:
    plt.plot(neighbors_all, nodes_5_5_poly_model_inv,   ls='-', color='r', label=' 5x5 model')
    plt.plot(neighbors_all, nodes_10_10_poly_model_inv, ls='-', color='g', label='10x10 model')
    plt.plot(neighbors_all, nodes_20_20_poly_model_inv, ls='-', color='b', label='20x20 model')

plt.ylim(0, 3000)

plt.legend()
plt.text(.5, .9,
          "K: " + str(K),
          horizontalalignment='center',
          verticalalignment='center',
          transform = ax.transAxes,
          bbox=dict(facecolor='red', alpha=0.2))
plt.savefig("sim/msg_neigh_k"+str(K)+".png")

#################
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111)

plt.title('#Messages vs 1/#Neighbors')
plt.xlabel("1/#Neighbors")
plt.ylabel("# Messages")

plt.plot(inv_neighbors, nodes_5_5,   marker='.', ls='None', markerfacecolor='r', markeredgecolor='None', markersize=10, label=' 5x5 simulated')
plt.plot(inv_neighbors, nodes_10_10, marker='.', ls='None', markerfacecolor='g', markeredgecolor='None', markersize=10, label='10x10 simulated')
plt.plot(inv_neighbors, nodes_20_20, marker='.', ls='None', markerfacecolor='b', markeredgecolor='None', markersize=10, label='20x20 simulated')

plt.plot(xp, nodes_5_5_poly(xp),   ls=':', color='r', label=' 5x5 linear fit')
plt.plot(xp, nodes_10_10_poly(xp), ls=':', color='g', label='10x10 linear fit')
plt.plot(xp, nodes_20_20_poly(xp), ls=':', color='b', label='20x20 linear fit')

if K != 0:
    plt.plot(xp, nodes_5_5_poly_model(xp),   ls='-', color='r', label=' 5x5 model')
    plt.plot(xp, nodes_10_10_poly_model(xp), ls='-', color='g', label='10x10 model')
    plt.plot(xp, nodes_20_20_poly_model(xp), ls='-', color='b', label='20x20 model')

plt.legend(loc='upper left')
plt.ylim(0, 3000)

plt.text(.5, .9,
          "K: " + str(K),
          horizontalalignment='center',
          verticalalignment='center',
          transform = ax.transAxes,
          bbox=dict(facecolor='red', alpha=0.2))
plt.savefig("sim/msg_neigh_inv_k"+str(K)+".png")

#plt.show()
