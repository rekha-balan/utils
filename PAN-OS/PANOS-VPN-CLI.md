## PAN-OS
### CLI Commands to Status, Clear, Restore and Monitor an IPSEC VPN Tunnel

The CLI commands in this document can be used to verify the status of an IPSEC tunnel, validate tunnel monitoring, clear the tunnel and restore the tunnel.


**Monitor the tunnel or verify that the tunnel is active:**

	show vpn flow

 - Note: For tunnel monitoring, a monitor status of down is an indicator that the destination IP being monitored is not reachable.

Example:

	show vpn flow

	total tunnels configured: 1
	filter - type IPSec, state any

	total IPSec tunnel configured: 1
	total IPSec tunnel shown: 1

	id name state monitor local-ip peer-ip tunnel-i/f
	--------------------------------------------------------------------------
	4 tunnel active up 172.17.128.135 172.17.128.1
 
**Confirm that data is passing through the tunnel:**

	show vpn flow tunnel-id x  << where x=id number from above display

 

Example:

The output below is at the bottom of the display and should be increasing as the traffic flows.

 

	show vpn flow tunnel-id 2
	        encap packets:    500
	        decap packets:    500
	        encap bytes:      54312
	        decap bytes:      54312
	        key acquire requests: 35

**View the details on the active IKE phase 1 SAs:**

	show vpn ike-sa gateway <gateway name>

 

Example:

	show vpn ike-sa gateway GW-to-Lab1
	 
	phase-1 SAs
	GwID  Peer-Address    Gateway Name    Role Mode Algorithm
	----  -------------  ---------------  ---------------------------               
	1    57.1.1.1        gw-to-Lab1      Init Main PSK/DH2/A128/SHA1
	 
	Show IKEv1 IKE SA: Total 1 gateways found.


**View the details on the active IKE phase 2 SAs:**

	show vpn ipsec-sa tunnel <tunnel name>

 

Example:

	show vpn ipsec-sa tunnel IPVPN-tunnel1.1-to-LAB1
	 
	GwID  TnID  Peer-Address  Tunnel(Gateway)          Algorithm     
	----  ----- ------------  -----------------------  ------------
	1     2     57.1.1.1      IPVPN-tunnel1.1-to-LAB1  ESP/A128/SHA1
	 
	Show IPSec SA: Total 1 tunnels found.


**The following commands will tear down the VPN tunnel:**

	clear vpn ike-sa gateway GW-to-Lab1
	Delete IKEv1 IKE SA: Total 1 gateways found.
	 
	clear vpn ipsec-sa tunnel IPVPN-tunnel1.1-to-LAB1
	Delete IKEv1 IPSec SA: Total 1 tunnels found.

 

**The following commands will bring up the VPN tunnel:**

- Initiate IKE phase 1

		test vpn ike-sa gateway GW-to-Lab1
		Initiate IKE SA: Total 1 gateways found. 1 ike sa found.


- Initiate IKE phase 2  

		test vpn ipsec-sa tunnel IPVPN-tunnel1.1-to-LAB1
		Initiate IPSec SA: Total 1 tunnels found. 1 ipsec sa found.