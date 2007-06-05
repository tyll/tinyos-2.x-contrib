package com.rincon.tunit.properties;

/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


/**
 * Like TUnitNodeProperties, but the properties are indexed by unique
 * target.  We can discover if a single target has multiple build options,
 * which would result in the target being built multiple times instead of once.
 * @author David Moss
 *
 */
public class TUnitTargetProperties {

  /** Name of this target */
  private String target;
  
  /** List of TUnitNodeProperties that use this target */
  private List nodes;
  
  /**
   * Constructor
   * @param targetName
   */
  public TUnitTargetProperties(String targetName) {
    target = targetName;
    nodes = new ArrayList();
  }
  
  /**
   * 
   * @return the name of this target
   */
  public String getTargetName() {
    return target;
  }
  
  /**
   * Add a node that uses this target
   * @param node
   */
  @SuppressWarnings("unchecked")
  public void addNode(TUnitNodeProperties node) {
    nodes.add(node);
  }
  
  /**
   * 
   * @return the total nodes that use this target in this test run
   */
  public int totalNodes() {
    return nodes.size();
  }
  
  /**
   * 
   * @param i
   * @return the TUnitNodeProperties at the given index
   */
  public TUnitNodeProperties getNode(int i) {
    return (TUnitNodeProperties) nodes.get(i);
  }
  
  /**
   * 
   * @return true if this target will require multiple builds, one for each node
   */
  public boolean requiresMultipleBuilds() {
    String buildExtras = null;
    TUnitNodeProperties focusedNode;
    for(Iterator it = nodes.iterator(); it.hasNext(); ) {
      focusedNode = (TUnitNodeProperties) it.next();
      if(buildExtras == null) {
        buildExtras = focusedNode.getBuildExtras();
        
      } else {
        if(!focusedNode.getBuildExtras().matches(buildExtras)) {
          return true;
        }
      }
    }
    
    return false;
  }
}
