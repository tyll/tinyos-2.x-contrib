//$Id$

/* 
 * Copyright (c)
 *
 */

/**
 * Function Description:
 * This class is one of the PacketAnalyzer
 *
 * It maintains the data structure of all nodes and edges 
 * in the network topology:
 *
 * when a new Network packet is recieved
 * look at the list and order of nodes in the hop-path
 * 1. if node/edge does not exist, triggle creat event of all listener;
 * 2. update the node/edge times, and triggle delete event of all
 *    listener if it is expired
 *
 * Original version by:
 *	  @author Wei Hong
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */



package monitor.PacketAnalyzer;



import Config.OasisConstants;
import SensorwebObject.TwoKeyHashtable;
import java.util.*;
import java.awt.*;
import monitor.Dialog.ActivePanel;
import monitor.Dialog.StandardDialog;
import monitor.MainClass;
import monitor.event.*;
import xml.RemoteObject.StreamDataObject;

 
public class ObjectMaintainer extends PacketAnalyzer implements Runnable
{
  //these variables define when to eliminate nodes that are no longer in the network
  protected static long nodeExpireTime;
  protected static long edgeExpireTime;
  protected static long nodeInitialPersistance;
  protected static long edgeInitialPersistance;
  protected static long nodeInitialDormancy;
  protected static long edgeInitialDormancy;
  //protected static long edgeStability;
  //protected static long networkSpeed;
  protected static long expirationCheckRate;
 
  public static Hashtable nodeInfo;
  public static TwoKeyHashtable edgeInfo;
  protected static Thread oldObjectDeleterThread;
  protected static Vector nodeListeners;
  protected static Vector edgeListeners;
  private static ArrayList parentAddress;
  private int count = 0;
  private int emailTrigger = 0;
  private String emailMessage = "";
  private ArrayList nodeDeletedLastMinute = new ArrayList();
  private ArrayList nodeCreatedLastMinute = new ArrayList();
  private Hashtable nodeStatus = new Hashtable();
  private boolean startEmailService = false;
  public static final short ALIVE = 1;
  public static final short DEATH = 2;
  public static final short CREATED = 0;


  public ObjectMaintainer()
  {

      this.register("object");

      //register myself to recieve NodeClickedEvents and EdgeClickedEvents
    MainClass.displayManager.AddNodeDialogContributor(this);
    MainClass.displayManager.AddEdgeDialogContributor(this);

    //all values are in milliseconds
   //8/6/2007
//    nodeExpireTime = 80000;
//    edgeExpireTime = 80000; //20000

    // 2007-10-01 18:25:18 ray
    nodeExpireTime = 20000;
    edgeExpireTime = 20000; //20000
    // -ray

   // nodeExpireTime = 40000;
   // edgeExpireTime = 40000; //20000
    nodeInitialPersistance = 2500;
    edgeInitialPersistance = 2500;
    nodeInitialDormancy = 7500;
    edgeInitialDormancy = 2500;
    expirationCheckRate = 1500;//in milliseconds

    nodeInfo = new Hashtable();
    edgeInfo = new TwoKeyHashtable();
    nodeListeners = new Vector();
    edgeListeners = new Vector();
    
	oldObjectDeleterThread = new Thread(this);
    try{
      oldObjectDeleterThread.setPriority(Thread.MIN_PRIORITY);
      oldObjectDeleterThread.start(); // call run()
    }
    catch(Exception e){e.printStackTrace();}
	
  }


  //this function constantly deletes old nodes and edges
  public void run()
  {
	  //System.out.println("run");
    while(true) {
      EliminateExpiredNodes();
      EliminateExpiredEdges();
      try {
		oldObjectDeleterThread.sleep(expirationCheckRate);
      }
      catch(Exception e){e.printStackTrace();}
    }
  }

  
  /**
   * Packet Recieved event handler
   *
   * when a new Network packet is recieved
   * look at the list and order of nodes in the hop-path
   * update the node times, create nodes that do not exist
   * update the edge times, create edges that do not exist
   *
   */
  

   @Override
    public synchronized void PacketReceived(String typeName,Vector streamEvent) {
      //System.out.println(typeName);
        
       Integer currentNodeNumber;
        Integer previousNodeNumber=new Integer(-1);
        NodeInfo currentNodeInfo;
        NodeInfo previousNodeInfo=null;
        EdgeInfo currentEdgeInfo;

        Date eventTime = new Date();
        Vector routePath = new Vector(2);
        //System.out.println(streamEvent.size());
        //Default parentaddr
       Integer currentNodeNo = new Integer((Integer)(((StreamDataObject)streamEvent.get(0)).data.get(0)));
 
        //   parentaddr = getParent(currentNodeNo);
        Integer  parentaddr = new Integer((Integer)(((StreamDataObject)streamEvent.get(1)).data.get(0)));
        //System.out.println("currentNodeNo" + currentNodeNo);
        //System.out.println("parentaddr" + parentaddr);
       if (parentaddr == null || parentaddr.intValue()== -1){
			return;
        }
        if (currentNodeNo.intValue() < 0 || currentNodeNo.intValue() > 255)
			return;
        if (parentaddr.intValue() < 0 || parentaddr.intValue() > 255)
			return;

       
       
        routePath.addElement(currentNodeNo);
        routePath.addElement(parentaddr);
         for(int count=0; count < routePath.size(); count++)	{


	  currentNodeNumber = (Integer)routePath.elementAt(count);

	  if((currentNodeInfo = (NodeInfo)nodeInfo.get(currentNodeNumber)) !=null){
			if( (currentNodeInfo.GetCreated()==false)
				 && NodeHasBeenSeenRecently(currentNodeInfo.GetTimeLastSeen(),
				                                                      eventTime)){
				  currentNodeInfo.SetCreated(true);
				  currentNodeInfo.SetTimeLastSeen(eventTime);
				  TriggerNodeCreatedEvent(new NodeEvent(this, currentNodeNumber,
					                      Calendar.getInstance().getTime()));

			} else {
				 currentNodeInfo.SetTimeLastSeen(eventTime);
			}
	  } else {
			//Andy: UART = PC if (currentNodeNumber.intValue() != (int)OasisConstants.UART_ADDRESS) {
				  currentNodeInfo = new NodeInfo(currentNodeNumber, eventTime);
			  nodeInfo.put(currentNodeNumber, currentNodeInfo);
				  currentNodeInfo.SetCreated(true);
				  TriggerNodeCreatedEvent(new NodeEvent(this, currentNodeNumber,
					                      Calendar.getInstance().getTime()));
			//}
	  	}


	  if(count != 0) {

		if( (currentEdgeInfo = (EdgeInfo)edgeInfo.get(previousNodeNumber,currentNodeNumber)) != null
			//song - 9/29/2007: following two lines added by Song to redraw the line if direction changes - this happens when parent select child as parent.
			&& currentEdgeInfo.GetSourceNodeNumber() == previousNodeNumber
			&& currentEdgeInfo.GetDestinationNodeNumber() == currentNodeNumber) {
			// - song
				currentEdgeInfo.SetTimeLastSeen(eventTime);
			}
		else if((currentNodeInfo!=null)
				        && (previousNodeInfo!=null)
				        &&(currentNodeInfo.GetCreated()
				        && previousNodeInfo.GetCreated()))
			{
				edgeInfo.put(previousNodeNumber,
					         currentNodeNumber,
					         new EdgeInfo(previousNodeNumber,
					                      currentNodeNumber,
					                      eventTime));
				TriggerEdgeCreatedEvent(new EdgeEvent(this, previousNodeNumber, currentNodeNumber, Calendar.getInstance().getTime()));
				
            //System.out.println("reach");

			}
      
		if(previousNodeInfo != null) {
				previousNodeInfo.SetParent(currentNodeNumber);
		}

	  } //End of if(count != 0)

	  previousNodeNumber = currentNodeNumber;
	  previousNodeInfo = currentNodeInfo;

	}     //end for loop through hop-list

   }

   //Andy
   private void initializePC(int moteID){
   		Integer currentNodeNumber;
	Integer previousNodeNumber=new Integer(-1);
	NodeInfo currentNodeInfo;
	NodeInfo previousNodeInfo=null;
	EdgeInfo currentEdgeInfo;
	Vector routePath = new Vector(2);
	Date eventTime = new Date();

	//Sinks
	Integer currentNodeNo = new Integer(moteID);

	//PC
	Integer  parentaddr = new Integer(OasisConstants.UART_ADDRESS);

	routePath.addElement(currentNodeNo);
	routePath.addElement(parentaddr);

	for(int count=0; count < routePath.size(); count++)	{
	  currentNodeNumber = (Integer)routePath.elementAt(count);
	  if((currentNodeInfo = (NodeInfo)nodeInfo.get(currentNodeNumber)) !=null){
			if( (currentNodeInfo.GetCreated()==false)
				 && NodeHasBeenSeenRecently(currentNodeInfo.GetTimeLastSeen(),
				                                                      eventTime)){
				  currentNodeInfo.SetCreated(true);
				  currentNodeInfo.SetTimeLastSeen(eventTime);
				  TriggerNodeCreatedEvent(new NodeEvent(this, currentNodeNumber,
					                      Calendar.getInstance().getTime()));

			} else {
				 currentNodeInfo.SetTimeLastSeen(eventTime);
			}
	  } else {
			//Andy: UART = PC if (currentNodeNumber.intValue() != (int)OasisConstants.UART_ADDRESS) {
				  currentNodeInfo = new NodeInfo(currentNodeNumber, eventTime);
				  nodeInfo.put(currentNodeNumber, currentNodeInfo);
				  currentNodeInfo.SetCreated(true);
				  TriggerNodeCreatedEvent(new NodeEvent(this, currentNodeNumber,
					                      Calendar.getInstance().getTime()));
			//}
	  }


	  if(count != 0) {

		if( (currentEdgeInfo = (EdgeInfo)edgeInfo.get(previousNodeNumber,currentNodeNumber)) != null
			//song - 9/29/2007: following two lines added by Song to redraw the line if direction changes - this happens when parent select child as parent.
			&& currentEdgeInfo.GetSourceNodeNumber() == previousNodeNumber
			&& currentEdgeInfo.GetDestinationNodeNumber() == currentNodeNumber) {
			// - song
				currentEdgeInfo.SetTimeLastSeen(eventTime);
			}
		else if((currentNodeInfo!=null)
				        && (previousNodeInfo!=null)
				        &&(currentNodeInfo.GetCreated()
				        && previousNodeInfo.GetCreated()))
			{
				edgeInfo.put(previousNodeNumber,
					         currentNodeNumber,
					         new EdgeInfo(previousNodeNumber,
					                      currentNodeNumber,
					                      eventTime));
				TriggerEdgeCreatedEvent(new EdgeEvent(this, previousNodeNumber, currentNodeNumber, Calendar.getInstance().getTime()));

			}
		if(previousNodeInfo != null) {
				previousNodeInfo.SetParent(currentNodeNumber);
		}

	  } //End of if(count != 0)
	  previousNodeNumber = currentNodeNumber;
	  previousNodeInfo = currentNodeInfo;
	}     //end for loop through hop-list


	 
	 
   }

  public static Integer getParent(Integer pNode){
    NodeInfo currentNodeInfo = (NodeInfo)nodeInfo.get(pNode);
    if(currentNodeInfo == null) return new Integer(-1);
    else return currentNodeInfo.GetParent();
  }



  //*****---NodeHasBeenSeenRecently---******//
  public boolean NodeHasBeenSeenRecently(Date TimeLastSeen, Date currentTime)
  {
	//if it has been seen in time less than nodeInitialDormancy
    if((currentTime.getTime() - nodeInitialDormancy)  <= TimeLastSeen.getTime()){
      return true;
    }
    return false;
  }


  //*****---Eliminiate Nodes---******//
  void EliminateExpiredNodes()
  {
    Integer currentNodeNumber;
    NodeInfo currentNodeInfo;
	
	//System.out.println("EliminateExpiredNodes");

    //for all nodes in the network
    long currentTime;
    for(Enumeration nodes = nodeInfo.elements();nodes.hasMoreElements();) 
    {
      currentNodeInfo = (NodeInfo)nodes.nextElement();
      currentNodeNumber = currentNodeInfo.GetNodeNumber();
	  
	if(currentNodeNumber.intValue() != 0){
		//if node has expired, eliminate it
		currentTime = Calendar.getInstance().getTime().getTime();//milliseconds since January 1, 1970
		if( (currentTime - currentNodeInfo.GetTimeLastSeen().getTime() > nodeExpireTime) &&
			(currentTime - currentNodeInfo.GetTimeCreated().getTime() > nodeInitialPersistance))
		{
			nodeInfo.remove(currentNodeNumber);
			TriggerNodeDeletedEvent(new NodeEvent(this, currentNodeNumber, 
				                    Calendar.getInstance().getTime()));
		}
      }
    }
			//Email if some node is missing
			
			emailTrigger++;
			if (emailTrigger >= 80) //2 minute
			{

				//System.out.println("emailTrigger");
				emailTrigger = 0;
				if (!emailMessage.equals(""))
				{

					String createdNode = "Node ";
					String deletedNode = "Node ";
					Enumeration enm = nodeStatus.keys();
					 while (enm.hasMoreElements()) {
						Integer moteNo = (Integer)enm.nextElement();
						Vector status_vector = (Vector)nodeStatus.get(moteNo);
						Integer lastMinuteStatus = (Integer)status_vector.get(0);
						Integer currentMinuteStatus = (Integer)status_vector.get(1);
						if (lastMinuteStatus.intValue() != CREATED && lastMinuteStatus.intValue() != currentMinuteStatus.intValue())
						{
							if (lastMinuteStatus.intValue() == ALIVE)
							{
								deletedNode += moteNo.intValue()+ ", ";
							}
							else if (lastMinuteStatus.intValue() == DEATH){
								createdNode += moteNo.intValue()+ ", ";
							}
						}
						status_vector.clear();
						status_vector.add(currentMinuteStatus);
						status_vector.add(currentMinuteStatus);
					 }
					
					 String title = "Sensorweb alert: ";
					 if (createdNode.equals("Node ") && deletedNode.equals("Node "))
					 {
						emailMessage = "";
						nodeCreatedLastMinute.clear();
						nodeDeletedLastMinute.clear();
						return;
					 }
					 if (!createdNode.equals("Node "))
					 {
						createdNode += " appears";
						title += createdNode;
					 }
					 if (!deletedNode.equals("Node "))
					 {
						deletedNode += " disappears";
						title += deletedNode;
					 }
					
					//System.out.println("startEmailService"+startEmailService);

					if (startEmailService)
					{
						
						try{
						
							

							/*
							if (nodeDeletedLastMinute.size() > 0)
							{
								
								title += "Node ";

								for (int i = 0 ; i < nodeDeletedLastMinute.size() ; i++ )
								{
									title += (Integer)nodeDeletedLastMinute.get(i)+", "; 
								}

								title += " disappears. ";
							}
							
							if (nodeCreatedLastMinute.size() > 0){

								title += "Node ";

								for (int i = 0 ; i < nodeCreatedLastMinute.size() ; i++ )
								{
									title += (Integer)nodeCreatedLastMinute.get(i)+", "; 
								}

								title += " appears";
							}
							*/
							
							MainClass.eventLogger.write(emailMessage +". Email to all clients \n");
							MainClass.eventLogger.flush();
							
							//System.out.println(emailMessage + ". Email to all clients");
							monitor.Util.sendEmail(title, title);
						}
						catch (Exception ex){
								ex.printStackTrace();
						}
						
					}

					emailMessage = "";
				}
				
				nodeCreatedLastMinute.clear();
				nodeDeletedLastMinute.clear();
			}
  
  }


  //*****---Eliminiate Edges---******//
  void EliminateExpiredEdges()
  {
    Integer sourceNumber;
    Integer destinationNumber;
    Integer currentEdgeNumber;
    EdgeInfo currentEdgeInfo;

    //for all edges in the network
    long currentTime; 
    for(Enumeration edges = edgeInfo.elements();edges.hasMoreElements();) {
      currentEdgeInfo = (EdgeInfo)edges.nextElement();
      //final vairables that don't need to be synchronized
	  sourceNumber = currentEdgeInfo.GetSourceNodeNumber();
	  //final vairables that don't need to be synchronized
      destinationNumber = currentEdgeInfo.GetDestinationNodeNumber();

      //if edge has expired, eliminate it
      currentTime = Calendar.getInstance().getTime().getTime();//milliseconds since January 1, 1970
      if( (currentTime - currentEdgeInfo.GetTimeLastSeen().getTime() > edgeExpireTime) &&
	  (currentTime - currentEdgeInfo.GetTimeCreated().getTime() > edgeInitialPersistance) ) {
		edgeInfo.remove(sourceNumber, destinationNumber);
		TriggerEdgeDeletedEvent(new EdgeEvent(this, sourceNumber, destinationNumber, 
			                                   Calendar.getInstance().getTime()));
      }
    }
  }


  //*****---ADD EVENT LISTENER---******//
  public static void AddNodeEventListener(NodeEventListener pListener)
  {
    nodeListeners.add(pListener);
  }

  public static void RemoveNodeEventListener(NodeEventListener pListener)
  {
    nodeListeners.remove(pListener);
  }

  public static void AddEdgeEventListener(EdgeEventListener pListener)
  {
    edgeListeners.add(pListener);
  }

  public static void RemoveEdgeEventListener(EdgeEventListener pListener)
  {
    edgeListeners.remove(pListener);
  }
 
  
  //*****---TRIGGER EVENTS---******//
  protected void TriggerNodeCreatedEvent(NodeEvent e)
  {
	Integer nodeNumber = e.GetNodeNumber();

		try {
			String logOutput = monitor.Util.getDateTime()   + " : " + "JAVA: Node "+nodeNumber.intValue()+" is created!";
			MainClass.eventLogger.write(logOutput + "\n");
			MainClass.eventLogger.flush();			
			System.out.println(logOutput);
			}
		catch (Exception ex){
		}
	
    //for each listener
    NodeEventListener currentListener;
    for(Enumeration list = nodeListeners.elements(); list.hasMoreElements();)
    {
      currentListener = (NodeEventListener)list.nextElement();
      currentListener.NodeCreated(e);//send the listener an event
    }
	
	try{
		String temp = monitor.Util.getDateTime()   + " : " + "JAVA: Node "+nodeNumber.intValue()+" appears!\n";
		emailMessage += temp;
		nodeCreatedLastMinute.add(nodeNumber);
		
		Vector statusVector = (Vector)nodeStatus.get(nodeNumber);
		if (statusVector == null){
			statusVector = new Vector();
			statusVector.add(new Integer(CREATED));
			statusVector.add(new Integer(ALIVE));
			nodeStatus.put(nodeNumber, statusVector);
		}
		else {
			statusVector.remove(1);
			statusVector.add(new Integer(ALIVE));
		}
	}
	catch (Exception ex){ex.printStackTrace();}
	

  }

  protected void TriggerNodeDeletedEvent(NodeEvent e)
  {
	Integer nodeNumber = e.GetNodeNumber();

		try {
			String logOutput = monitor.Util.getDateTime()   + " : " + "JAVA: Node "+nodeNumber.intValue()+" is deleted!";
			MainClass.eventLogger.write(logOutput + "\n");
			MainClass.eventLogger.flush();			
			System.out.println(logOutput);
			}
		catch (Exception ex){
		}
	
	//for each listener
    NodeEventListener currentListener;
    for(Enumeration list = nodeListeners.elements(); list.hasMoreElements();)
    {
      currentListener = (NodeEventListener)list.nextElement();
      currentListener.NodeDeleted(e);//send the listener an event
    }			

	startEmailService = true;
	
	try{
		String temp = monitor.Util.getDateTime()   + " : " + "JAVA: Node "+nodeNumber.intValue()+" disappears!\n";
		emailMessage += temp;
		nodeDeletedLastMinute.add(nodeNumber);
		
		Vector statusVector = (Vector)nodeStatus.get(nodeNumber);
		statusVector.remove(1);
		statusVector.add(new Integer(DEATH));
	}
	catch (Exception ex){ex.printStackTrace();}
	
  }

  protected void TriggerEdgeCreatedEvent(EdgeEvent e)
  {
    //for each listener
    EdgeEventListener currentListener;
    for(Enumeration list = edgeListeners.elements(); list.hasMoreElements();)
    {		
      currentListener = (EdgeEventListener)list.nextElement();
      currentListener.EdgeCreated(e);//send the listener an event
    }			
  }

  protected void TriggerEdgeDeletedEvent(EdgeEvent e)
  {
    //for each listener
    EdgeEventListener currentListener;
    for(Enumeration list = edgeListeners.elements(); list.hasMoreElements();)
    {
      currentListener = (EdgeEventListener)list.nextElement();
      currentListener.EdgeDeleted(e);//send the listener an event
    }			
  }


  public void EdgeClicked(EdgeClickedEvent e){}
  public void NodeClicked(NodeClickedEvent e){}


  //*****---Thread commands---******//
  public void start(){ try{ oldObjectDeleterThread=new Thread(this);oldObjectDeleterThread.start();} catch(Exception e){e.printStackTrace();}}
  // public void stop(){ try{ oldObjectDeleterThread.stop();} catch(Exception e){e.printStackTrace();}}
  public void sleep(long p){ try{ oldObjectDeleterThread.sleep(p);} catch(Exception e){e.printStackTrace();}}
  public void setPriority(int p) { try{oldObjectDeleterThread.setPriority(p);} catch(Exception e){e.printStackTrace();}}    



  //*****---GET/SET commands---******//
  public long GetNodeExpireTime() { return nodeExpireTime;}    
  public long GetEdgeExpireTime() { return edgeExpireTime;}    
  public long GetEdgeInitialPersisistance() { return edgeInitialPersistance;}    
  public long GetNodeInitialPersisistance() { return nodeInitialPersistance;}    
  public long GetExpirationCheckRate() { return expirationCheckRate;}  


  public void SetNodeExpireTime(long p) { nodeExpireTime = p;}    
  public void SetEdgeExpireTime(long p) { edgeExpireTime = p;}    
  public void SetEdgeInitialPersisistance(long p) { edgeInitialPersistance = p;}    
  public void SetNodeInitialPersisistance(long p) { nodeInitialPersistance = p;}    
  public void SetExpirationCheckRate(long p) { expirationCheckRate = p;}    



  /**
   * NODE MAINTANCE INFO CLASS
   *
   */
  public class NodeInfo
  {
    protected Integer nodeNumber;
    protected boolean base;
    protected Integer parent;
    protected Date timeCreated;
    protected Date timeLastSeen;
    protected Date secondToLastTimeSeen;
    protected Vector motesConnectedTo;
    protected boolean created;

    public NodeInfo(Integer pNodeNumber, Date time)
    {
      nodeNumber = pNodeNumber;
      timeCreated = time;
      timeLastSeen = time;
      secondToLastTimeSeen = time;
      created = false;
    }

    public Integer GetNodeNumber(){return nodeNumber;}
    public Date GetTimeCreated()
    {
      return timeCreated;
    }

    public void SetTimeCreated(Date time)
    {
      timeCreated = time;
    }

    public Date GetTimeLastSeen()
    {
      return timeLastSeen;
    }

    public Date GetSecondToLastTimeSeen()
    {
      return secondToLastTimeSeen;
    }

    public void SetTimeLastSeen(Date time)
    {
      secondToLastTimeSeen = timeLastSeen;
      timeLastSeen = time;
    }
    public boolean GetCreated(){return created;}
    public void SetCreated(boolean pCreated){created = pCreated;}
    public Integer GetParent(){return parent;}
    public void SetParent(Integer pParent){parent = pParent;}
    public void SetBase(boolean pbase){base = pbase;}
    public boolean GetBase(){return nodeNumber.intValue() == 0;}
  }
 
  
  /**
   * EDGE MAINTAINECE INFO CLASS
   *
   */
  public class EdgeInfo
  {
    protected Integer sourceNodeNumber;
    protected Integer destinationNodeNumber;
    protected Date timeCreated;
    protected Date timeLastSeen;

    public EdgeInfo(Integer pSourceNodeNumber, 
		            Integer pDestinationNodeNumber, Date time)
    {
      sourceNodeNumber = pSourceNodeNumber;
      destinationNodeNumber = pDestinationNodeNumber;
      timeCreated = time;
      timeLastSeen = time;
    }

    public Integer GetSourceNodeNumber(){return sourceNodeNumber;}
    public Integer GetDestinationNodeNumber(){return destinationNodeNumber;}
    public Date GetTimeCreated()
    {
      return timeCreated;
    }

    public void SetTimeCreated(Date time)
    {
      timeCreated = time;
    }

    public Date GetTimeLastSeen()
    {
      return timeLastSeen;
    }

    public void SetTimeLastSeen(Date time)
    {
      timeLastSeen = time;
    }
  }
  
  
  //Note: unused funtions below!

  
  //*****---SHOW PROPERTIES DIALOG---******//
  public void ShowPropertiesDialog()
  {
    StandardDialog newDialog = new StandardDialog(new ObjectMaintainerPropertiesPanel(this));
    newDialog.show();
  }

    @Override
  public ActivePanel GetProprietaryNodeInfoPanel(Integer pNodeNumber)
  {
    return new ProprietaryNodeInfoPanel((NodeInfo)nodeInfo.get(pNodeNumber));
  }

    @Override
  public ActivePanel GetProprietaryEdgeInfoPanel(Integer pSourceNodeNumber, Integer pDestinationNodeNumber)
  {
    EdgeInfo info = (EdgeInfo)edgeInfo.get(pSourceNodeNumber, pDestinationNodeNumber);
    if(info==null) return null;
    return new ProprietaryEdgeInfoPanel(info);
  }

  //NODE INFO PANEL
  public class ProprietaryNodeInfoPanel extends monitor.Dialog.ActivePanel
  {
    NodeInfo nodeInfo;

    public ProprietaryNodeInfoPanel(NodeInfo pNodeInfo)
    {
      tabTitle = "Creation";
      nodeInfo = pNodeInfo;
      setLayout(null);
      //			Insets ins = getInsets();
      setSize(307,168);
      JLabel3.setToolTipText("The time in milliseconds that this node was first seen");
      JLabel3.setText("Time Created:");
      add(JLabel3);
      JLabel3.setBounds(12,36,108,24);
      JLabel4.setToolTipText("The time in milliseconds that this node was last seen");
      JLabel4.setText("Time Last Seen");
      add(JLabel4);
      JLabel4.setBounds(12,60,108,24);
      JTextField1.setNextFocusableComponent(JTextField2);
      JTextField1.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
      JTextField1.setText("1.5");
      add(JTextField1);
      JTextField1.setBounds(108,36,180,18);
      JTextField2.setNextFocusableComponent(JTextField3);
      JTextField2.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
      JTextField2.setText("3.2");
      add(JTextField2);
      JTextField2.setBounds(108,60,180,18);
      JLabel1.setToolTipText("The second to last time seen");
      JLabel1.setText("Time Before");
      add(JLabel1);
      JLabel1.setBounds(12,84,90,18);
      JTextField3.setNextFocusableComponent(JTextField1);
      JTextField3.setToolTipText("The second to last time seen");
      JTextField3.setText("4.5");
      add(JTextField3);
      JTextField3.setBounds(108,84,180,18);
      JLabel2.setText("Node Number:");
      add(JLabel2);
      JLabel2.setFont(new Font("Dialog", Font.BOLD, 16));
      JLabel2.setBounds(48,0,120,39);
      JLabel5.setToolTipText("The number used to identify this node");
      JLabel5.setText("jlabel");
      add(JLabel5);
      JLabel5.setForeground(java.awt.Color.blue);
      JLabel5.setFont(new Font("Dialog", Font.BOLD, 16));
      JLabel5.setBounds(180,0,48,33);

    }

    javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
    javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
    javax.swing.JTextField JTextField1 = new javax.swing.JTextField();
    javax.swing.JTextField JTextField2 = new javax.swing.JTextField();
    javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
    javax.swing.JTextField JTextField3 = new javax.swing.JTextField();
    javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
    javax.swing.JLabel JLabel5 = new javax.swing.JLabel();

    public void ApplyChanges()
    {
      //nodeInfo.SetTimeCreated(new Date(JTextField1.getText()));
      //nodeInfo.SetTimeLastSeen(new Date(JTextField2.getText()));
    }

    public void InitializeDisplayValues()
    {
      JTextField1.setText(String.valueOf(nodeInfo.GetTimeCreated()));
      JTextField2.setText(String.valueOf(nodeInfo.GetTimeLastSeen()));
      JTextField3.setText(String.valueOf(nodeInfo.GetSecondToLastTimeSeen()));
      JLabel5.setText(String.valueOf(nodeInfo.GetNodeNumber()));
    }
  }	          

  
  //EDGE INFO PANEL
  public class ProprietaryEdgeInfoPanel extends monitor.Dialog.ActivePanel
  {
    EdgeInfo edgeInfo;

    public ProprietaryEdgeInfoPanel(EdgeInfo pedgeInfo)
    {
      tabTitle = "Creation";
      edgeInfo = pedgeInfo;
      setLayout(null);
      //			Insets ins = getInsets();
      setSize(307,168);
      JLabel3.setToolTipText("The time in milliseconds that this node was first seen");
      JLabel3.setText("Time Created:");
      add(JLabel3);
      JLabel3.setBounds(24,60,108,24);
      JLabel4.setToolTipText("The time in milliseconds that this node was last seen");
      JLabel4.setText("Time Last Seen");
      add(JLabel4);
      JLabel4.setBounds(24,84,108,24);
      JTextField1.setNextFocusableComponent(JTextField2);
      JTextField1.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
      JTextField1.setText("1.5");
      add(JTextField1);
      JTextField1.setBounds(120,60,180,18);
      JTextField2.setNextFocusableComponent(JTextField1);
      JTextField2.setToolTipText("The scale of the coordinate system is determined by the user, and scaled automatically by the system to fit to the screen");
      JTextField2.setText("3.2");
      add(JTextField2);
      JTextField2.setBounds(120,84,180,18);
      JLabel2.setText("Source Node Number:");
      add(JLabel2);
      JLabel2.setBounds(24,12,156,12);
      JLabel1.setText("Destination Node Number");
      add(JLabel1);
      JLabel1.setBounds(24,36,150,15);
      JLabel5.setText("jlabel");
      add(JLabel5);
      JLabel5.setBounds(192,12,36,12);
      JLabel6.setText("jlabel");
      add(JLabel6);
      JLabel6.setBounds(192,36,36,18);

    }

    javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
    javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
    javax.swing.JTextField JTextField1 = new javax.swing.JTextField();
    javax.swing.JTextField JTextField2 = new javax.swing.JTextField();
    javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
    javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
    javax.swing.JLabel JLabel5 = new javax.swing.JLabel();
    javax.swing.JLabel JLabel6 = new javax.swing.JLabel();

    public void ApplyChanges()
    {
      edgeInfo.SetTimeCreated(new Date(Long.getLong(JTextField1.getText()).longValue()));
      edgeInfo.SetTimeLastSeen(new Date(Long.getLong(JTextField2.getText()).longValue()));
    }

    public void InitializeDisplayValues()
    {
      JLabel5.setText(edgeInfo.GetSourceNodeNumber().toString());
      JLabel6.setText(edgeInfo.GetDestinationNodeNumber().toString());
      JTextField1.setText(String.valueOf(edgeInfo.GetTimeCreated()));
      JTextField2.setText(String.valueOf(edgeInfo.GetTimeLastSeen()));
    }
  }	          
 
  
  //OBJECT MAINTAINER PROPERTIES PANEL
  //to be shown in a standard dialog
  public class ObjectMaintainerPropertiesPanel extends ActivePanel
  {
    ObjectMaintainer objectMaintainer;

    public ObjectMaintainerPropertiesPanel(ObjectMaintainer pObjectMaintainer)
    {
      tabTitle = "Object Maintainer Properties";
      modal=true;
      objectMaintainer = pObjectMaintainer;

      setLayout(null);
      setSize(286,264);
      add(nodeExpire);
      nodeExpire.setBounds(36,12,156,52);
      NodeExpireLabel.setText("label1");
      add(NodeExpireLabel);
      NodeExpireLabel.setBounds(204,12,47,52);
      nodeExpireSlider.setMinimum(100);
      nodeExpireSlider.setMaximum(10000);
      nodeExpireSlider.setToolTipText("The time before this node is deleted, since it last seen.");
      // nodeExpireSlider.setBorder(bevelBorder1);
      nodeExpireSlider.setValue(100);
      add(nodeExpireSlider); 
      nodeExpireSlider.setBounds(60,48,192,24);
      nodeInitialPersistance.setText("Node Initial Persistance:");
      add(nodeInitialPersistance);
      nodeInitialPersistance.setBounds(36,60,156,52);
      nodeInitialPersistanceLabel.setText("label2");
      add(nodeInitialPersistanceLabel);
      nodeInitialPersistanceLabel.setBounds(204,60,47,52);
      nodeInitialPersistanceSlider.setMinimum(100);
      nodeInitialPersistanceSlider.setMaximum(10000);
      nodeInitialPersistanceSlider.setToolTipText("The time before a node is deleted, since it was first seen.");
      // nodeInitialPersistanceSlider.setBorder(bevelBorder1);
      nodeInitialPersistanceSlider.setOpaque(false);
      nodeInitialPersistanceSlider.setValue(100);
      add(nodeInitialPersistanceSlider); 
      nodeInitialPersistanceSlider.setForeground(java.awt.Color.lightGray);
      nodeInitialPersistanceSlider.setBounds(60,96,192,24);
      edgeExpire.setText("Edge Expire Time:");
      add(edgeExpire);
      edgeExpire.setBounds(36,108,156,52);
      edgeExpireLabel.setText("label3");
      add(edgeExpireLabel);
      edgeExpireLabel.setBounds(204,108,47,52);
      edgeExpireSlider.setMinimum(100);
      edgeExpireSlider.setMaximum(10000);
      edgeExpireSlider.setToolTipText("The time before an edge is deleted, since it was last seen");
      // edgeExpireSlider.setBorder(bevelBorder1);
      edgeExpireSlider.setValue(100);
      add(edgeExpireSlider); 
      edgeExpireSlider.setBounds(60,144,192,24);
      edgeInitialPersistance.setText("Edge Initial Persistance:");
      add(edgeInitialPersistance);
      edgeInitialPersistance.setBounds(36,156,156,52);
      edgeInitialPersistanceLabel.setText("label4");
      add(edgeInitialPersistanceLabel);
      edgeInitialPersistanceLabel.setBounds(204,156,47,52);
      edgeInitialPersistanceSlider.setMinimum(100);
      edgeInitialPersistanceSlider.setMaximum(10000);
      edgeInitialPersistanceSlider.setToolTipText("The time before an edge is deleted, since it was first seen.");
      // edgeInitialPersistanceSlider.setBorder(bevelBorder1);
      edgeInitialPersistanceSlider.setValue(100);
      add(edgeInitialPersistanceSlider); 
      edgeInitialPersistanceSlider.setForeground(java.awt.Color.lightGray);
      edgeInitialPersistanceSlider.setBounds(60,192,192,24);
      expirationCheckRate.setText("Expiration Check Rate");
      add(expirationCheckRate);
      expirationCheckRate.setBounds(36,204,159,51);
      expirationCheckRateLabel.setText("label5");
      add(expirationCheckRateLabel);
      expirationCheckRateLabel.setBounds(204,204,48,51);
      JLabel1.setToolTipText("1 second is 1000 milliseconds");
      expirationCheckRateSlider.setValue(100);
      JLabel1.setText("Note: all times are in milliseconds");
      add(JLabel1);
      JLabel1.setForeground(java.awt.Color.blue);
      JLabel1.setBounds(48,0,219,21);
      expirationCheckRateSlider.setMinimum(100);
      expirationCheckRateSlider.setMaximum(10000);
      expirationCheckRateSlider.setToolTipText("The rate at which the Object Maintainer goes through all the objects and deletes old ones.  ");
      // expirationCheckRateSlider.setBorder(bevelBorder1);
      add(expirationCheckRateSlider);
      expirationCheckRateSlider.setBackground(new java.awt.Color(204,204,204));
      expirationCheckRateSlider.setForeground(java.awt.Color.lightGray);
      expirationCheckRateSlider.setBounds(60,240,192,24);

      nodeExpire.setText("Node Expire Time:");
      //$$ bevelBorder1.move(0,306);

      SymChange lSymChange = new SymChange();
      nodeExpireSlider.addChangeListener(lSymChange);
      nodeInitialPersistanceSlider.addChangeListener(lSymChange);
      edgeExpireSlider.addChangeListener(lSymChange);
      edgeInitialPersistanceSlider.addChangeListener(lSymChange);
      expirationCheckRateSlider.addChangeListener(lSymChange);
    }

    javax.swing.JLabel nodeExpire = new javax.swing.JLabel();
    javax.swing.JLabel NodeExpireLabel = new javax.swing.JLabel();
    javax.swing.JSlider nodeExpireSlider = new javax.swing.JSlider();
    javax.swing.JLabel nodeInitialPersistance = new javax.swing.JLabel();
    javax.swing.JLabel nodeInitialPersistanceLabel = new javax.swing.JLabel();
    javax.swing.JSlider nodeInitialPersistanceSlider = new javax.swing.JSlider();
    javax.swing.JLabel edgeExpire = new javax.swing.JLabel();
    javax.swing.JLabel edgeExpireLabel = new javax.swing.JLabel();
    javax.swing.JSlider edgeExpireSlider = new javax.swing.JSlider();
    javax.swing.JLabel edgeInitialPersistance = new javax.swing.JLabel();
    javax.swing.JLabel edgeInitialPersistanceLabel = new javax.swing.JLabel();
    javax.swing.JSlider edgeInitialPersistanceSlider = new javax.swing.JSlider();
    javax.swing.JLabel expirationCheckRate = new javax.swing.JLabel();
    javax.swing.JLabel expirationCheckRateLabel = new javax.swing.JLabel();
    javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
    javax.swing.JSlider expirationCheckRateSlider = new javax.swing.JSlider();
    // com.symantec.itools.javax.swing.borders.BevelBorder bevelBorder1 = new com.symantec.itools.javax.swing.borders.BevelBorder();

    //---------------------------------------------------------------------
    //APPLY CHANGES
    public void ApplyChanges()
    {
      objectMaintainer.SetNodeExpireTime(nodeExpireSlider.getValue());
      objectMaintainer.SetEdgeExpireTime(edgeExpireSlider.getValue());
      objectMaintainer.SetEdgeInitialPersisistance(edgeInitialPersistanceSlider.getValue());
      objectMaintainer.SetNodeInitialPersisistance(nodeInitialPersistanceSlider.getValue());
      objectMaintainer.SetExpirationCheckRate(expirationCheckRateSlider.getValue());
    }
    //APPLY CHANGES
    //---------------------------------------------------------------------


    //---------------------------------------------------------------------
    //INITIALIZE DISPLAY VALUES
    public void InitializeDisplayValues()
    {
      NodeExpireLabel.setText(String.valueOf(objectMaintainer.GetNodeExpireTime()));
      nodeExpireSlider.setValue((int)objectMaintainer.GetNodeExpireTime());
      nodeInitialPersistanceLabel.setText(String.valueOf(objectMaintainer.GetNodeInitialPersisistance()));
      nodeInitialPersistanceSlider.setValue((int)objectMaintainer.GetNodeInitialPersisistance());
      edgeExpireLabel.setText(String.valueOf(objectMaintainer.GetEdgeExpireTime()));
      edgeExpireSlider.setValue((int)objectMaintainer.GetEdgeExpireTime());
      edgeInitialPersistanceLabel.setText(String.valueOf(objectMaintainer.GetEdgeInitialPersisistance()));
      edgeInitialPersistanceSlider.setValue((int)objectMaintainer.GetEdgeInitialPersisistance());
      expirationCheckRateLabel.setText(String.valueOf(objectMaintainer.GetExpirationCheckRate()));
      expirationCheckRateSlider.setValue((int)objectMaintainer.GetExpirationCheckRate());

      //This function is called by a thread that runs in the background
      //and updates the values of the Active Panels so they are always
      //up to date.
    }
    //INITIALIZE DISPLAY VALUES
    //---------------------------------------------------------------------

    class SymChange implements javax.swing.event.ChangeListener
    {
      public void stateChanged(javax.swing.event.ChangeEvent event)
      {
	Object object = event.getSource();
	if (object == nodeExpireSlider)
	  nodeExpireSlider_stateChanged(event);
	else if (object == nodeInitialPersistanceSlider)
	  nodeInitialPersistanceSlider_stateChanged(event);
	else if (object == edgeExpireSlider)
	  edgeExpireSlider_stateChanged(event);
	else if (object == edgeInitialPersistanceSlider)
	  edgeInitialPersistanceSlider_stateChanged(event);
	else if (object == expirationCheckRateSlider)
	  expirationCheckRateSlider_stateChanged(event);
      }
    }

    void nodeExpireSlider_stateChanged(javax.swing.event.ChangeEvent event)
    {
      // to do: code goes here.

      nodeExpireSlider_stateChanged_Interaction1(event);
    }

    void nodeExpireSlider_stateChanged_Interaction1(javax.swing.event.ChangeEvent event)
    {
      try {
	// convert int->class java.lang.String
	NodeExpireLabel.setText(java.lang.String.valueOf(nodeExpireSlider.getValue()));
      } catch (java.lang.Exception e) {
      }
    }

    void nodeInitialPersistanceSlider_stateChanged(javax.swing.event.ChangeEvent event)
    {
      // to do: code goes here.

      nodeInitialPersistanceSlider_stateChanged_Interaction1(event);
    }

    void nodeInitialPersistanceSlider_stateChanged_Interaction1(javax.swing.event.ChangeEvent event)
    {
      try {
	// convert int->class java.lang.String
	nodeInitialPersistanceLabel.setText(java.lang.String.valueOf(nodeInitialPersistanceSlider.getValue()));
      } catch (java.lang.Exception e) {
      }
    }

    void edgeExpireSlider_stateChanged(javax.swing.event.ChangeEvent event)
    {
      // to do: code goes here.

      edgeExpireSlider_stateChanged_Interaction1(event);
    }

    void edgeExpireSlider_stateChanged_Interaction1(javax.swing.event.ChangeEvent event)
    {
      try {
	// convert int->class java.lang.String
	edgeExpireLabel.setText(java.lang.String.valueOf(edgeExpireSlider.getValue()));
      } catch (java.lang.Exception e) {
      }
    }

    void edgeInitialPersistanceSlider_stateChanged(javax.swing.event.ChangeEvent event)
    {
      // to do: code goes here.

      edgeInitialPersistanceSlider_stateChanged_Interaction1(event);
    }

    void edgeInitialPersistanceSlider_stateChanged_Interaction1(javax.swing.event.ChangeEvent event)
    {
      try {
	// convert int->class java.lang.String
	edgeInitialPersistanceLabel.setText(java.lang.String.valueOf(edgeInitialPersistanceSlider.getValue()));
      } catch (java.lang.Exception e) {
      }
    }

    void expirationCheckRateSlider_stateChanged(javax.swing.event.ChangeEvent event)
    {
      // to do: code goes here.

      expirationCheckRateSlider_stateChanged_Interaction1(event);
    }

    void expirationCheckRateSlider_stateChanged_Interaction1(javax.swing.event.ChangeEvent event)
    {
      try {
	// convert int->class java.lang.String
	expirationCheckRateLabel.setText(java.lang.String.valueOf(expirationCheckRateSlider.getValue()));
      } catch (java.lang.Exception e) {
      }
    }
  }
}
