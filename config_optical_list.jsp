<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.inspur.rsi.service.BaseService"%>
<%@ page import="java.util.List"%>
<html>
<head>
<%
String now_status=request.getParameter("now_status");
if (null==now_status) now_status = "0";
String flowId=request.getParameter("flowId");
//String netScene=request.getParameter("netScene");
//String netScene="4";
String mainFlowId=null;//做为主流程的id号进行处理
if(flowId!=null && !flowId.equals("")){
 mainFlowId=flowId;
}
String subFlowId=request.getParameter("subFlowId");
if (null!=subFlowId && !"".equals(subFlowId) && !"null".equals(subFlowId)) {
	flowId = subFlowId;
}
String rejectFlag=(String)request.getAttribute("rejectFlag");
String rejectValue=(String)request.getAttribute("rejectValue");
String cityId=(String)request.getAttribute("cityId");
String operFlag = request.getParameter("operFlag");      //正常流转还是历史环节  2-正常流转；1-历史查看
System.out.println("----0827--operFlag-"+operFlag);


String sql = "select b.int_id from irms.t_bns_trans_ne_in a ,c_ne_region b where a.company_name=b.region_name and b.stateflag=0 and a.flow_id = '" + flowId + "' ";
String region_id = "";
BaseService baseServ = new BaseService();
try {
	List list = baseServ.searchBySQL(sql);
	if(list != null && list.size() > 0) {
		region_id = ((Object[])list.get(0))[0].toString();
	}
	System.out.println("##region_id=" + region_id);
} catch (Exception e) {
	e.printStackTrace();
}
 %>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 启动组件 -->
<jsp:include page="/jsp/app/inc/script_include.jsp"></jsp:include>

<script language="javascript">
	var operFlag="<%=operFlag%>";
	var region_id = '<%=region_id%>';
	var  isHidden=false;
	if(operFlag=='1'){
		isHidden=true;
	}
	var flowId="<%=flowId%>";
	var rejectFlag="<%=rejectFlag%>";
	var rejectValue="<%=rejectValue%>";
	var cityId="<%=cityId%>";
	var activeName="${activeName}";
	var needTransCir="<%=request.getParameter("needTransCir")%>";
	if (needTransCir==null || needTransCir=="" || needTransCir=="null") needTransCir="0";
	var now_status = "<%=now_status%>";
	var specialty="传输";
	var vHidden1 = true;//电路操作
	var vHidden2 = true;//增加删除光路
	var vHidden3 = true;//编辑光路
	var vHidden4 = true;//修改现场路由
	var vHidden5 = true;//管线施工图片下载
	if('gldd' == activeName) {
		vHidden2 = false;
		vHidden3 = false;
	} else if('wyxxws' == activeName) {
		vHidden3 = false;
	}
	
	if(operFlag != '2'&& operFlag != '') {
		vHidden1 = true;
		vHidden2 = true;
		vHidden3 = true;
		vHidden4 = true;
		vHidden5 = true;
	}
	if(now_status == '1') {
		vHidden1 = true;
		vHidden2 = true;
		vHidden3 = true;
		vHidden4 = true;
		vHidden5 = true;
	}
	Ext.onReady(function(){
		/*var store=new Ext.data.JsonStore({
			proxy:new Ext.data.HttpProxy({
				url:'${pageContext.request.contextPath}/transOpticalAction!initOpticalPage.ilf?flowId='+flowId,
				timeout:300000
			}),
			root:'root',
			totalProperty:'totalProperty',
			sortInfo:{field:'intId', direction: "ASC"},
			fields: [
			  {name: 'intId'},
			  {name: 'port_change'},
			  {name: 'transsystem_change'},
			  {name: 'rout_change'},
			  {name: 'addordel'},
			  {name: 'acityname'},
			  {name: 'asitename'},
			  {name: 'aroomname'},
			  {name: 'zcityname'},
			  {name: 'zsitename'},
			  {name: 'zroomname'},
			  {name: 'transsysname'},
			  {name: 'transsyspro'},
			  {name: 'transsysno'},
			  {name: 'isSingleText'},
			  {name: 'remark'},
			  {name: 'logicalcode'},
			  {name: 'addordel'}
			]
		});
		
		store.load();
		*/
		var circuitEnum=new Ext.util.MixedCollection();
		/*电路类型*/
		circuitEnum.add("机房","ROOM");
		circuitEnum.add("资源点","LOCALPOINT");
		circuitEnum.add("集客机房","CUSTOM_ROOM");
		circuitEnum.add("光交接箱","O_OSWBOX");
		circuitEnum.add("BBU","BBU");
		circuitEnum.add("RRU","RRU");
		circuitEnum.add("2G基站","2GSTATION");
		circuitEnum.add("BSC","BSC");
		circuitEnum.add("4G基站","4GSTATION");
		circuitEnum.add("传输设备","TRANSNE");
		circuitEnum.add("POS","POS");
		circuitEnum.add("ONU","ONU");
		circuitEnum.add("BRAS_SR","BRAS_SR");
		circuitEnum.add("OLT","OLT");
		circuitEnum.add("MGW","MGW");
		circuitEnum.add("RRU到RRU","1");
		circuitEnum.add("RRU到BBU","2");
		circuitEnum.add("BBU到传输设备","3");
		circuitEnum.add("4G基站到传输设备","4");
		circuitEnum.add("BSC到2G基站","5");
		circuitEnum.add("PON方式:POS到ONU","6");
		circuitEnum.add("传输方式","7");
		circuitEnum.add("裸光纤:BRAS到ONU","8");
		circuitEnum.add("PON方式:OLT到光交","9");
		circuitEnum.add("OLT到BRAS","11");
		circuitEnum.add("BSC到MGW","12");
		//业务对象
		var CircuitInfo = Ext.data.Record.create([
			{name:'id',type:'string'},
			{name:'flowId',type:'string'},
			{name:'circuitType',type:'string'},
			{name:'infoType',type:'string'},
			{name:'circuitState',type:'string'},
			{name:'fiberCount',type:'string'},
			{name:'alocalType',type:'string'},
			{name:'alocalId',type:'string'},
			{name:'alocalName',type:'string'},
			{name:'aequipmentType',type:'string'},
			{name:'aequipmentId',type:'string'},
			{name:'aequipmentName',type:'string'},
			{name:'aportId',type:'string'},
			{name:'aportName',type:'string'},
			{name:'zlocalType',type:'string'},
			{name:'zlocalId',type:'string'},
			{name:'zlocalName',type:'string'},
			{name:'zequipmentType',type:'string'},
			{name:'zequipmentId',type:'string'},
			{name:'zequipmentName',type:'string'},
			{name:'zportId',type:'string'},
			{name:'zportName',type:'string'},
			{name: 'fiberCode',type:'string'},
			{name: 'fiberName',type:'string'}
			
			]);
		var loadMask = new Ext.LoadMask(Ext.getBody(), {
			msg : "加载中..."
		});
		var commonFiels=[
		         	 	{name: 'id'},
		         	 	  {name: 'flowId'},
		         	 	  {name: 'addordel'},
		         	 	  {name: 'circuitType'},
		         		  {name: 'infoType'},
		         		  {name: 'circuitState'},
		         		  {name: 'fiberCount'},
		         		  {name: 'alocalType'},
		         		  {name: 'alocalId'},
		         		  {name: 'alocalName'},
		         		  {name: 'aequipmentType'},
		         		  {name: 'aequipmentId'},
		         		  {name: 'aequipmentName'},
		         		  {name: 'aportId'},
		         		  {name: 'aportName'},
		         		  {name: 'zlocalType'},
		         		  {name: 'zlocalId'},
		         		  {name: 'zlocalName'},
		         		  {name: 'zequipmentType'},
		         		  {name: 'zequipmentId'},
		         		  {name: 'zequipmentName'},
		         		  {name: 'zportId'},
		         		  {name: 'zportName'},
		         		  {name: 'schedulingRoute'},
		         		  {name: 'sceneRoute'},
		         		  {name: 'fiberCode'},
		         		  {name: 'fiberName'}
		         	];
		var commonCmDl=new Ext.grid.ColumnModel({
			columns:[
			new Ext.grid.RowNumberer(),
	    	new Ext.grid.CheckboxSelectionModel(),
	    	{header: "id", width:100, sortable: true, dataIndex: 'id'},
	    	{header: "flowId", width:100, sortable: true, dataIndex: 'flowId',hidden:true},
	    	{header: "类型",	width:120, sortable: true, dataIndex: 'addordel'},
	    	{header: "光电属性",	width:80, sortable: true, dataIndex: 'infoType'},
	    	{header: "光电状态",	width:100, sortable: true, dataIndex: 'circuitState'},
	    	{header: "A端位置点类型",	width:120, sortable: true, dataIndex: 'alocalType'},
	    	{header: "A端位置点名称",	width:200, sortable: true, dataIndex: 'alocalName'},
	    	{header: "A端设备类型",	width:100, sortable: true, dataIndex: 'aequipmentType'},
	    	{header: "A端设备",	width:200, sortable: true, dataIndex: 'aequipmentName'},
	    	{header: "A端端口",	width:200, sortable: true, dataIndex: 'aportName'},
	    	{header: "Z端位置点类型",	width:120, sortable: true, dataIndex: 'zlocalType'},
	    	{header: "Z端位置点名称",	width:200, sortable: true, dataIndex: 'zlocalName'},
	    	{header: "Z端设备类型",	width:100, sortable: true, dataIndex: 'zequipmentType'},
	    	{header: "Z端设备",	width:200, sortable: true, dataIndex: 'zequipmentName'},
	    	{header: "Z端端口",	width:200, sortable: true, dataIndex: 'zportName'}
	    ]});
	    var store=new Ext.data.JsonStore({
			proxy:new Ext.data.HttpProxy({
				url:"bussConfigjsAction!queryCircuit.ilf",
				timeout:300000
			}),
			root:'root',
			totalProperty:'totalProperty',
			sortInfo:{field:'id', direction: "ASC"},
			baseParams:{start:0,limit:10,flowId:flowId,infoType:'光路'},
			fields: commonFiels
		});
	    store.load();
		var opticalPanel=new Ext.grid.GridPanel({
			width:document.body.clientWidth-20,
			height:500,
			title:'光路信息列表',
			collapsible:true,
			frame:true,
			store:store,
			loadMask:true,
			cm:commonCmDl,
			autoScroll : true,
//			autoWidth : true,
			layout : "fit",
			/*cm:new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
	        	new Ext.grid.CheckboxSelectionModel(),
	        	{header: "intId", width:100, sortable: true, dataIndex: 'intId',hidden:true},
	        	{header: "设备端口变更",	width:120, sortable: true, dataIndex: 'port_change',renderer:function(value){
           			   if(value=="1"){
           			      return "是";
           			   }else{
           			      return "否";
           			   }
           			}},
	        	{header: "所属传输系统变更",	width:120, sortable: true, dataIndex: 'transsystem_change',renderer:function(value){
           			   if(value=="1"){
           			      return "是";
           			   }else{
           			      return "否";
           			   }
           			}},
	        	{header: "变更纤芯路由",	width:120, sortable: true, dataIndex: 'rout_change',renderer:function(value){
           			   if(value=="1"){
           			      return "是";
           			   }else{
           			      return "否";
           			   }
           			}},
	        	{header: "类型",	width:120, sortable: true, dataIndex: 'addordel'},
	        	{header: "起始点地市",	width:120, sortable: true, dataIndex: 'acityname'},
	        	{header: "起始点站点",	width:120, sortable: true, dataIndex: 'asitename'},
	        	{header: "起始点机房",	width:120, sortable: true, dataIndex: 'aroomname'},
	        	
	        	{header: "终止点地市",	width:120, sortable: true, dataIndex: 'zcityname'},
	        	{header: "终止点站点",	width:120, sortable: true, dataIndex: 'zsitename'},
	        	{header: "终止点机房",	width:120, sortable: true, dataIndex: 'zroomname'},
	        	{header: "光路逻辑编码",	width:120, sortable: true, dataIndex: 'logicalcode'},
	        	{header: "传输系统名称",	width:150, sortable: true, dataIndex: 'transsysname'},
	        	{header: "光路类别",	width:150, sortable: true, dataIndex: 'isSingleText'},
	        	//{header: "光路名称",	width:150, sortable: true, dataIndex: 'transsyspro'},
	        	{header: "备注", width:300, sortable: true, dataIndex: 'remark'}
	        ]),*/
			sm:new Ext.grid.CheckboxSelectionModel(),
			
			stripeRows: true,
			viewConfig:{
				forceFit:true,
				enableRowBody:true
			},
			bbar:new Ext.PagingToolbar({
				pageSize:10,
				store:store,
				displayInfo:true,
				displayMsg:'Displaying topics {0} - {1} of {2}',
				emptyMsg:'没有相关数据'
			}),
			buttonAlign:'left',
			buttons:[
			{
        		id:'addCir',
        		text:'增加光路',
        		hidden : vHidden2,
				disabled:now_status=="1"?true:false,
				handler:function(){
					addCommonInfos('光路',opticalPanel);
        		}
        	},
        	{
        		id:'editCir',
        		text:'修改光路',
        		hidden : vHidden3,
				disabled:now_status=="1"?true:false,
				handler:function(){
					if(opticalPanel.getStore().data.length==1) {
						addCommonInfos('光路',opticalPanel,opticalPanel.getStore().data.items[0].id,opticalPanel.getStore().data.items[0]);
					} else {
						var records = opticalPanel.getSelectionModel().getSelections();
						if(records.length!=1){
							Ext.Msg.alert("提示","请选择一条数据")
						}else{
							var ids = records[0].data.id;
							addCommonInfos('光路',opticalPanel,ids,records[0]);
						}
					}
        		}
        	},
        	{
        		id:'delCir',
        		text:'删除光路',
        		hidden : vHidden2,
				disabled:now_status=="1"?true:false,
				handler:function(){
					delCommonfun("CIRCUIT",opticalPanel);
					/*
        			var circuitRecords=opticalPanel.getSelectionModel().getSelections();
        			if(circuitRecords.length==0){
						Ext.Msg.alert("系统消息","请至少选择一条电路进行操作");
						return;
					}
					var ids="";
					var applyids="";
					for(var i=0;i<circuitRecords.length;i++){
						ids+=circuitRecords[i].data.intId;
						applyids+=circuitRecords[i].data.applyid;
						if(i<circuitRecords.length-1){
							ids+=",";
							applyids+=",";
						}
					}
					Ext.Ajax.request({
						url: context_path + '/transOpticalAction!delOptical.ilf',
						params: { 
							ids : ids,
							applyids : applyids
						},
						success: function(response){
							Ext.Msg.alert("提示","数据删除" + response.responseText);
							store.reload();
						}
					});
					*/
        		}
        	}
        	]
		});
		
		
		opticalPanel.render("circuitData");
		function change(ve){
			return "000";
		}
		/**
		 * 通用删除临时表方法
		 * equtype CIRCUIT 
		 * miaingrid  需要刷新的gridpanel
		 * */
		function delCommonfun(equtype,miaingrid){
			var opticRecords=miaingrid.getSelectionModel().getSelections();
			if(opticRecords.length<1){
				Ext.Msg.alert("系统消息","请选择至少一条数据进行操作!");
				return;
			}
			var idscurrent="";
			for(var i=0;i<opticRecords.length;i++){
				idscurrent+=opticRecords[i].data.id;
				if(i<opticRecords.length-1){
					idscurrent+=",";
				}
			}
			Ext.Msg.show({
				title:'提示', 
				msg: '确认要删除此数据吗？',
				modal: true, 
				buttons: Ext.Msg.YESNO, 
				icon: Ext.Msg.INFO,
				fn:function(flag){
					if(flag=="yes"){
						Ext.MessageBox.show({
					           msg: '正在执行操作,请稍候...',
					           progressText: '保存数据中 ...',
					           progress:true,
					           width:300,
					           wait:true,
					           waitConfig: {interval:200},
					           icon:'ext-mb-download', 
					           animEl: 'mb7'
				       });					
						Ext.Ajax.request({
							url:'bussConfigjsAction!delCommon.ilf',
							params: {
								ids : idscurrent,
								equType:equtype
							},
							success: function(response){
								var res = Ext.decode(response.responseText);
								if(res.success==true){
									 Ext.Msg.alert("提示","操作成功",function(){
									 Ext.MessageBox.hide();
									 miaingrid.store.reload();
									});
								}else{
									Ext.Msg.alert("提示",response.responseText,function(){
										Ext.MessageBox.hide();
										miaingrid.store.reload();
									});
								}
								
							}
						});
					}
				}
			})
				
		}
		/**
		 *新增方法通用 
		 *infoType 电路，光路
		 *maingrid 需要刷新的gridpanel
		 *ids  有值的话，表示是编辑按钮 
		 *checkedRecord 被选中的记录
		 *hiddenlevel 隐藏级别
		 * */
		function addCommonInfos(infoType,maingrid,ids,checkedRecord,hiddenlevel){
			var astoredata = [["ROOM","机房"],["LOCALPOINT","资源点"]];
			if(specialty=='集客') {
				astoredata = [["ROOM","机房"],["LOCALPOINT","资源点"],["O_OSWBOX","光交接箱"]];
			}
			var astoretype = new Ext.data.SimpleStore({
				data:astoredata,
				fields:['value','text']
			});
			var alocalTypeField = new Ext.form.ComboBox({
				store: astoretype,
				emptyText: "请选择",
				mode: "local",
				triggerAction: "all",
				valueField: "value",
				minChars: 1,
				typeAhead: false,
				displayField: "text",
				width:300,
				disabled : vHidden2&&infoType=='光路',
				fieldLabel :"A端位置点类型<font color=red>*</font>",
				listeners:{
					select:function(combo,record,index){
						infos.set("alocalType",combo.getRawValue());
					},
					change:function(){
						
					}
				}
			}); 
			
			var zstoredata = [["ROOM","机房"],["LOCALPOINT","资源点"]];
			if(specialty=='集客') {
				zstoredata = [["ROOM","机房"],["LOCALPOINT","资源点"],["CUSTOM_ROOM","集客机房"],["O_OSWBOX","光交接箱"]];
			} else if(specialty=='家客') {
				zstoredata = [["O_OSWBOX","光交接箱"]];
			}
			var zstoretype = new Ext.data.SimpleStore({
				data:zstoredata,
				fields:['value','text']
			});
			var zlocalTypeField = new Ext.form.ComboBox({
				store: zstoretype,
				emptyText: "请选择",
				mode: "local",
				triggerAction: "all",
				valueField: "value",
				minChars: 1,
				typeAhead: false,
				displayField: "text",
				width:300,
				disabled : vHidden2&&infoType=='光路',
				fieldLabel :"Z端位置点类型<font color=red>*</font>",
				listeners:{
					select:function(combo,record,index){
						infos.set("zlocalType",combo.getRawValue());
					},
					change:function(){
						
					}
				}
			}); 
			var localCombA= new Ext.form.ComboBox({
				width : 300,
				disabled : vHidden2&&infoType=='光路',
				fieldLabel : "A端位置点<font color=red>*</font>",
				triggerAction : 'all',
				forceSelection:true,
				valueField : 'int_id',
				displayField : 'zh_label',
				mode : 'remote',
				minChars : 0,
				pageSize : 10,
				listWidth : 270,
//				disabled:now_status,
				queryParam : 'zh_label',
				store : new Ext.data.JsonStore({
							totalProperty : 'totalProperty',
							root : 'root',
							url : context_path + '/bussConfigjsAction!queryResourceRoom.ilf',
							fields : ['zh_label', 'int_id'],
							baseParams:{equType:'',start:0,limit:10},
							listeners : {
								beforeload : function(s) { 
								 	s.baseParams.equType = alocalTypeField.getValue();
								 	s.baseParams.regionId = region_id;
								 	//s.baseParams.projectCode = emps_porject_no;
									 
								}
						 }	 		
				}),
				listeners : {
					select : function(combo,record,index) {
						infos.set("alocalId",combo.getValue());
						infos.set("alocalName",combo.getRawValue());
						/*清除位置点下已选设备和端口*/
						equCombA.setValue("");
						equCombA.setRawValue("");
						portCombA.setValue("");
						portCombA.setRawValue("");
						infos.set("aequipmentId","");
						infos.set("aequipmentName","");
						infos.set("aportId","");
						infos.set("aportName","");
						viewTopo(win);
					},
					beforequery : function(qe) {
						delete qe.combo.lastQuery;
					}
				}
			});
			var localCombZ= new Ext.form.ComboBox({
				width : 300,
				disabled : vHidden2&&infoType=='光路',
				fieldLabel : "Z端位置点<font color=red>*</font>",
				triggerAction : 'all',
				forceSelection:true,
				valueField : 'int_id',
				displayField : 'zh_label',
				mode : 'remote',
				minChars : 0,
				pageSize : 10,
				listWidth : 270,
//				disabled:now_status,
				queryParam : 'zh_label',
				store : new Ext.data.JsonStore({
							totalProperty : 'totalProperty',
							root : 'root',
							url : context_path + '/bussConfigjsAction!queryResourceRoom.ilf',
							fields : ['zh_label', 'int_id'],
							baseParams:{equType:'',start:0,limit:10},
							listeners : {
								beforeload : function(s) { 
									s.baseParams.equType = zlocalTypeField.getValue();
									s.baseParams.regionId = region_id;
									//s.baseParams.projectCode = emps_porject_no;
								}
						 }	 		
				}),
				listeners : {
					select : function(combo,record,index) {
						infos.set("zlocalId",combo.getValue());
						infos.set("zlocalName",combo.getRawValue());
						/*清除位置点下已选设备和端口*/
						equCombZ.setValue("");
						equCombZ.setRawValue("");
						portCombZ.setValue("");
						portCombZ.setRawValue("");
						infos.set("zequipmentId","");
						infos.set("zequipmentName","");
						infos.set("zportId","");
						infos.set("zportName","");
						viewTopo(win);
					},
					beforequery : function(qe) {
						delete qe.combo.lastQuery;
					}
				}
			});
			
			var astoreEqutype = new Ext.data.SimpleStore({
				data:[["RRU","RRU"],["BBU","BBU"],["POS","POS"],["TRANSNE","传输设备"],["BRAS_SR","BRAS_SR"],["OLT","OLT"],["BSC","BSC"]],
				fields:['value','text']
	        });
			var zstoreEqutype = new Ext.data.SimpleStore({
				data:[["RRU","RRU"],["BBU","BBU"],["TRANSNE","传输设备"],["ONU","ONU"],["BRAS_SR","BRAS_SR"],["MGW","MGW"]],
				fields:['value','text']
	        });
			
			var storeEqutypeData = [["1","RRU到RRU"],["2","RRU到BBU"],["3","BBU到传输设备"]];
			if(specialty=='集客') {
				storeEqutypeData = [["6","PON方式:POS到ONU"],["7","传输方式"],["8","裸光纤:BRAS到ONU"]];
			} else if(specialty=='家客') {
				storeEqutypeData = [["9","PON方式:OLT到光交"]];
			} else if(specialty=='传输') {
				storeEqutypeData = [["7","传输方式"],["11","OLT到BRAS"]];
			} else if(specialty=='核心') {
				storeEqutypeData = [["12","BSC到MGW"]];
			}
			
			var storeEqutype = new Ext.data.SimpleStore({
				data:storeEqutypeData,
				fields:['value','text']
	        });
			var combEqutype = new Ext.form.ComboBox({
				store: storeEqutype,
		   		mode: "local",
		   		triggerAction: "all",
		   		valueField: "value",
		   		minChars: 1,
		   		typeAhead: false,
		   		displayField: "text",
		   		width:300,
		   		disabled : vHidden2&&infoType=='光路',
		   		fieldLabel :"设备类型<font color=red>*</font>",
		   		listeners:{
		        	select:function(combo,record,index){
		        		infos.set("circuitType",combo.getRawValue());
		        		
		        		equCombA.setValue("");
						equCombA.setRawValue("");
						portCombA.setValue("");
						portCombA.setRawValue("");
						infos.set("aequipmentId","");
						infos.set("aequipmentName","");
						infos.set("aportId","");
						infos.set("aportName","");
						equCombZ.setValue("");
						equCombZ.setRawValue("");
						portCombZ.setValue("");
						portCombZ.setRawValue("");
						infos.set("zequipmentId","");
						infos.set("zequipmentName","");
						infos.set("zportId","");
						infos.set("zportName","");
		        		if("1"==combo.getValue()) {
		        			infos.set("aequipmentType","RRU");
		        			combEqutypeA.setValue("RRU");
							combEqutypeA.setRawValue("RRU");
		        			infos.set("zequipmentType","RRU");
							combEqutypeZ.setValue("RRU");
							combEqutypeZ.setRawValue("RRU");
		        		} else if("2"==combo.getValue()) {
		        			infos.set("aequipmentType","RRU");
		        			combEqutypeA.setValue("RRU");
							combEqutypeA.setRawValue("RRU");
		        			infos.set("zequipmentType","BBU");
							combEqutypeZ.setValue("BBU");
							combEqutypeZ.setRawValue("BBU");
		        		} else if("3"==combo.getValue()) {
		        			infos.set("aequipmentType","BBU");
		        			combEqutypeA.setValue("BBU");
							combEqutypeA.setRawValue("BBU");
		        			infos.set("zequipmentType","传输设备");
							combEqutypeZ.setValue("TRANSNE");
							combEqutypeZ.setRawValue("传输设备");
		        		} else if("4"==combo.getValue()) {
		        			infos.set("aequipmentType","4G基站");
		        			combEqutypeA.setValue("4GSTATION");
							combEqutypeA.setRawValue("4G基站");
		        			infos.set("zequipmentType","传输设备");
							combEqutypeZ.setValue("TRANSNE");
							combEqutypeZ.setRawValue("传输设备");
		        		} else if("5"==combo.getValue()) {
		        			infos.set("aequipmentType","BSC");
		        			combEqutypeA.setValue("BSC");
							combEqutypeA.setRawValue("BSC");
		        			infos.set("zequipmentType","2G基站");
							combEqutypeZ.setValue("2GSTATION");
							combEqutypeZ.setRawValue("2G基站");
		        		} else if("6"==combo.getValue()) {
		        			infos.set("aequipmentType","POS");
		        			combEqutypeA.setValue("POS");
							combEqutypeA.setRawValue("POS");
		        			infos.set("zequipmentType","ONU");
							combEqutypeZ.setValue("ONU");
							combEqutypeZ.setRawValue("ONU");
		        		} else if("7"==combo.getValue()) {
		        			infos.set("aequipmentType","传输设备");
		        			combEqutypeA.setValue("TRANSNE");
							combEqutypeA.setRawValue("传输设备");
		        			infos.set("zequipmentType","传输设备");
							combEqutypeZ.setValue("TRANSNE");
							combEqutypeZ.setRawValue("传输设备");
		        		} else if("8"==combo.getValue()) {
		        			infos.set("aequipmentType","BRAS_SR");
		        			combEqutypeA.setValue("BRAS_SR");
							combEqutypeA.setRawValue("BRAS_SR");
		        			infos.set("zequipmentType","ONU");
							combEqutypeZ.setValue("ONU");
							combEqutypeZ.setRawValue("ONU");
		        		} else if("9"==combo.getValue()) {
		        			infos.set("aequipmentType","OLT");
		        			combEqutypeA.setValue("OLT");
							combEqutypeA.setRawValue("OLT");
		        			infos.set("zequipmentType","ONU");
							combEqutypeZ.setValue("ONU");
							combEqutypeZ.setRawValue("ONU");
		        		} else if("11"==combo.getValue()) {
		        			infos.set("aequipmentType","OLT");
		        			combEqutypeA.setValue("OLT");
							combEqutypeA.setRawValue("OLT");
		        			infos.set("zequipmentType","BRAS_SR");
							combEqutypeZ.setValue("BRAS_SR");
							combEqutypeZ.setRawValue("BRAS_SR");
		        		} else if("12"==combo.getValue()) {
		        			infos.set("aequipmentType","BSC");
		        			combEqutypeA.setValue("BSC");
							combEqutypeA.setRawValue("BSC");
		        			infos.set("zequipmentType","MGW");
							combEqutypeZ.setValue("MGW");
							combEqutypeZ.setRawValue("MGW");
		        		}
		        		viewTopo(win);
		        	}
		        }
			});
			var location1 = new Ext.form.Label({
				fieldLabel : ' ',
				labelSeparator:''
			});
			
	        var combEqutypeA = new Ext.form.ComboBox({
				store: astoreEqutype,
		   		mode: "local",
		   		triggerAction: "all",
		   		valueField: "value",
		   		minChars: 1,
		   		typeAhead: false,
		   		displayField: "text",
		   		width:300,
		   		fieldLabel :"A端设备类型<font color=red>*</font>",
		   		listeners:{
		        	select:function(combo,record,index){
						infos.set("aequipmentType",combo.getRawValue());
						/*清除已选设备和端口*/
						equCombA.setValue("");
						equCombA.setRawValue("");
						portCombA.setValue("");
						portCombA.setRawValue("");
						infos.set("aequipmentId","");
						infos.set("aequipmentName","");
						infos.set("aportId","");
						infos.set("aportName","");
		        	}
		        }
			});
			 var combEqutypeZ = new Ext.form.ComboBox({
				store: zstoreEqutype,
		   		mode: "local",
		   		triggerAction: "all",
		   		valueField: "value",
		   		minChars: 1,
		   		typeAhead: false,
		   		displayField: "text",
		   		width:300,
		   		fieldLabel :"Z端设备类型<font color=red>*</font>",
		   		listeners:{
		        	select:function(combo,record,index){
		        		infos.set("zequipmentType",combo.getRawValue());
		        		/*清除已选设备和端口*/
						equCombZ.setValue("");
						equCombZ.setRawValue("");
						portCombZ.setValue("");
						portCombZ.setRawValue("");
						infos.set("zequipmentId","");
						infos.set("zequipmentName","");
						infos.set("zportId","");
						infos.set("zportName","");
		        	}
		        }
			});
			var equCombA= new Ext.form.ComboBox({
				width : 300,
				fieldLabel : "A端设备",
				triggerAction : 'all',
				forceSelection:true,
				valueField : 'int_id',
				displayField : 'zh_label',
				mode : 'remote',
				minChars : 0,
				pageSize : 10,
				listWidth : 270,
//				disabled:now_status,
				queryParam : 'zh_label',
				store : new Ext.data.JsonStore({
							totalProperty : 'totalProperty',
							root : 'root',
							url : context_path + '/bussConfigjsAction!queryResourceEquipment2.ilf',
							fields : ['zh_label', 'int_id'],
							baseParams:{equType:'',start:0,limit:10},
							listeners : {
								beforeload : function(s) { 
									if(isnull(localCombA.getValue())){
										Ext.Msg.alert("提示","请选择A端位置点");
										return;
									}else if(isnull(combEqutypeA.getValue())){
										Ext.Msg.alert("提示","请选择A端设备类型");
										return;
									}else{
										 s.baseParams.regionId = region_id;
									 	 s.baseParams.equType = combEqutypeA.getValue();
									 	 s.baseParams.roomId = localCombA.getValue();
									 	 s.baseParams.roomType = alocalTypeField.getValue();
									}
									 
								}
						 }	 		
				}),
				listeners : {
					select : function(combo,record,index) {
						infos.set("aequipmentId",combo.getValue());
						infos.set("aequipmentName",combo.getRawValue());
						/*清除设备下已选端口*/
						portCombA.setValue("");
						portCombA.setRawValue("");
						infos.set("aportId","");
						infos.set("aportName","");
						viewTopo(win);
					},
					beforequery : function(qe) {
						delete qe.combo.lastQuery;
					}
				}
			});
			var equCombZ= new Ext.form.ComboBox({
				width : 300,
				fieldLabel : "Z端设备",
				triggerAction : 'all',
				forceSelection:true,
				valueField : 'int_id',
				displayField : 'zh_label',
				mode : 'remote',
				minChars : 0,
				pageSize : 10,
				listWidth : 270,
//				disabled:now_status,
				queryParam : 'zh_label',
				store : new Ext.data.JsonStore({
							totalProperty : 'totalProperty',
							root : 'root',
							url : context_path + '/bussConfigjsAction!queryResourceEquipment2.ilf',
							fields : ['zh_label', 'int_id', 'bsc_int_id', 'bsc_int_id_transName', 'machineroom_id', 'machineroom_id_transName'],
							baseParams:{equType:'',start:0,limit:10},
							listeners : {
								beforeload : function(s) { 
									if(isnull(localCombZ.getValue())){
										Ext.Msg.alert("提示","请选择Z端位置点");
										return;
									}else if(isnull(combEqutypeZ.getValue())){
										Ext.Msg.alert("提示","请选择Z端设备类型");
										return;
									}else{
										 s.baseParams.regionId = region_id;
									 	 s.baseParams.equType = combEqutypeZ.getValue();
									 	 s.baseParams.roomId = localCombZ.getValue();
									 	 s.baseParams.roomType = zlocalTypeField.getValue();
									}
									 
								}
						 }	 		
				}),
				listeners : {
					select : function(combo,record,index) {
						infos.set("zequipmentId",combo.getValue());
						infos.set("zequipmentName",combo.getRawValue());
						/*清除设备下已选端口*/
						portCombZ.setValue("");
						portCombZ.setRawValue("");
						infos.set("zportId","");
						infos.set("zportName","");
//						if("2GSTATION"==combEqutypeZ.getValue()&&infoType=='电路') {
//							//设置BSC
//							infos.set("aequipmentId",record.data.bsc_int_id);
//							infos.set("aequipmentName",record.data.bsc_int_id_transName);
//							equCombA.setValue(record.data.bsc_int_id);
//							equCombA.setRawValue(record.data.bsc_int_id_transName);
//							/*清除设备下已选端口*/
//							portCombA.setValue("");
//							portCombA.setRawValue("");
//							infos.set("aportId","");
//							infos.set("aportName","");
//							//设置机房
//							infos.set("alocalId",record.data.machineroom_id);
//							infos.set("alocalName",record.data.machineroom_id_transName);
//							localCombA.setValue(record.data.machineroom_id);
//							localCombA.setRawValue(record.data.machineroom_id_transName);
//						}
						viewTopo(win);
					},
					beforequery : function(qe) {
						delete qe.combo.lastQuery;
					}
				}
			});
			var portCombA= new Ext.form.ComboBox({
				width : 300,
				fieldLabel : "A端端口",
				triggerAction : 'all',
				forceSelection:infoType=='光路'?false:true,
				valueField : 'int_id',
				displayField : 'zh_label',
				mode : 'remote',
				minChars : 0,
				pageSize : 10,
				listWidth : 270,
//				disabled:now_status,
				queryParam : 'zh_label',
				store : new Ext.data.JsonStore({
							totalProperty : 'totalProperty',
							root : 'root',
							url : context_path + '/bussConfigjsAction!queryResourcePort2.ilf',
							fields : ['zh_label', 'int_id'],
							baseParams:{equType:'PORT',start:0,limit:10},
							listeners : {
								beforeload : function(s) { 
									if(isnull(equCombA.getValue())){
										Ext.Msg.alert("提示","请选择A端设备")
										return;
									}else if(isnull(combEqutypeA.getValue())){
										Ext.Msg.alert("提示","请选择A端设备类型")
										return;
									}else{
										s.baseParams.equType = combEqutypeA.getValue();
									 	s.baseParams.equipmentId = equCombA.getValue();
									}
									 
								}
						 }	 		
				}),
				listeners : {
					select : function(combo,record,index) {
						infos.set("aportId",combo.getValue());
						infos.set("aportName",combo.getRawValue());
					},
					beforequery : function(qe) {
						delete qe.combo.lastQuery;
					}
				}
			});
			var portCombZ= new Ext.form.ComboBox({
				width : 300,
				fieldLabel : "Z端端口",
				triggerAction : 'all',
				forceSelection:infoType=='光路'?false:true,
				valueField : 'int_id',
				displayField : 'zh_label',
				mode : 'remote',
				minChars : 0,
				pageSize : 10,
				listWidth : 270,
//				disabled:now_status,
				queryParam : 'zh_label',
				store : new Ext.data.JsonStore({
							totalProperty : 'totalProperty',
							root : 'root',
							url : context_path + '/bussConfigjsAction!queryResourcePort2.ilf',
							fields : ['zh_label', 'int_id'],
							baseParams:{equType:'PORT',start:0,limit:10},
							listeners : {
								beforeload : function(s) { 
									if(isnull(equCombZ.getValue())){
										Ext.Msg.alert("提示","请选择Z端设备")
										return;
									}else if(isnull(combEqutypeZ.getValue())){
										Ext.Msg.alert("提示","请选择Z端设备类型")
										return;
									}else{
										s.baseParams.equType = combEqutypeZ.getValue();
									 	s.baseParams.equipmentId = equCombZ.getValue();
									}
									 
								}
						 }	 		
				}),
				listeners : {
					select : function(combo,record,index) {
						infos.set("zportId",combo.getValue());
						infos.set("zportName",combo.getRawValue());
					},
					beforequery : function(qe) {
						delete qe.combo.lastQuery;
					}
				}
			});
			
			var fiberCountAZStore = new Ext.data.SimpleStore({
				data:[["单纤","单纤"],["双纤","双纤"]],
				fields:['value','text']
			});
			var fiberCountAZ = new Ext.form.ComboBox({
				hidden : false,
				store: fiberCountAZStore,
				emptyText: "请选择",
				mode: "local",
				triggerAction: "all",
				valueField: "value",
				minChars: 1,
				typeAhead: false,
				displayField: "text",
				width:300,
				fieldLabel :"光路单双纤类型<font color=red>*</font>",
				listeners : {
					select : function(combo,record,index) {
						infos.set("fiberCount",combo.getValue());
					},
					beforequery : function(qe) {
						delete qe.combo.lastQuery;
					}
				}
			}); 
			
			var aitemsPanel = [alocalTypeField,localCombA,combEqutype,equCombA,portCombA,fiberCountAZ]
			var bussinfoPanel=new Ext.form.FormPanel({
				layout:"column",
				width:1000,
				border : false,
				autoScroll:true,
				bodyStyle : "background-color : #DFE8F6;padding: 20 0 0 30",
				items:[
				{
					xtype:"panel",
					columnWidth:.5,
					layout:"form",
					bodyStyle : "background-color : #DFE8F6",
					border : false,
		//			autoScroll:true,
					items:aitemsPanel
				},{
					xtype:"panel",
					columnWidth:.5,
					layout:"form",
					bodyStyle : "margin-left:44px;background-color : #DFE8F6",
					border : false,
		//			autoScroll:true,
					items:[
						zlocalTypeField,localCombZ,location1,equCombZ,portCombZ
					]
				}
				
				]
			});
			
			var win=new Ext.Window({
				title:specialty+"-"+infoType+"信息",
				width:1020,
				height:480,
				x:10,
				y:50,
				items:[
			    	bussinfoPanel
				],
				listeners:{
					close:function(w){
						win.destroy();
					},
					afterrender:function(){
						if(isnull(ids)){
							infos=new CircuitInfo();
							infos.set("infoType",infoType);
							infos.set("flowId",flowId);
							infos.set("circuitState","未发起");
							alocalTypeField.setValue("ROOM");
							alocalTypeField.setRawValue("机房");
							zlocalTypeField.setValue("ROOM");
							zlocalTypeField.setRawValue("机房");
							infos.set("alocalType","机房");
							infos.set("zlocalType","机房");
						}else{
							infos=checkedRecord;
							infos.set("flowId",flowId);
							alocalTypeField.setValue(circuitEnum.get(infos.get("alocalType")));
							alocalTypeField.setRawValue(infos.get("alocalType"));
							localCombA.setValue(infos.get("alocalId"));
							localCombA.setRawValue(infos.get("alocalName"));
							combEqutypeA.setValue(circuitEnum.get(infos.get("aequipmentType")));
							combEqutypeA.setRawValue(infos.get("aequipmentType"));
							equCombA.setValue(infos.get("aequipmentId"));
							equCombA.setRawValue(infos.get("aequipmentName"));
							portCombA.setValue(infos.get("aportId"));
							portCombA.setRawValue(infos.get("aportName"));
							
							zlocalTypeField.setValue(circuitEnum.get(infos.get("zlocalType")));
							zlocalTypeField.setRawValue(infos.get("zlocalType"));
							localCombZ.setValue(infos.get("zlocalId"));
							localCombZ.setRawValue(infos.get("zlocalName"));
							combEqutypeZ.setValue(circuitEnum.get(infos.get("zequipmentType")));
							combEqutypeZ.setRawValue(infos.get("zequipmentType"));
							equCombZ.setValue(infos.get("zequipmentId"));
							equCombZ.setRawValue(infos.get("zequipmentName"));
							portCombZ.setValue(infos.get("zportId"));
							portCombZ.setRawValue(infos.get("zportName"));
							fiberCountAZ.setValue(infos.get("fiberCount"));
							fiberCountAZ.setRawValue(infos.get("fiberCount"));
							
							combEqutype.setValue(circuitEnum.get(infos.get("circuitType")));
							combEqutype.setRawValue(infos.get("circuitType"));
						}
						
					}
				},
				buttonAlign:'center',
				buttons:[
				{
					text:"保存信息",
//					iconCls: "addB",
					handler:function(){
						infos.set("aportName",portCombA.getRawValue());
						infos.set("zportName",portCombZ.getRawValue());
						infos.set("addordel","新增");
						if(isnull(infos.get("alocalId"))||isnull(infos.get("zlocalId"))){
							Ext.Msg.alert("提示信息","位置点不能为空");
							return;
						}else if(isnull(infos.get("alocalType"))||isnull(infos.get("zlocalType"))){
							Ext.Msg.alert("提示信息","位置点类型不能为空");
							return;
						}else if(isnull(infos.get("aequipmentType"))||isnull(infos.get("zequipmentType"))){
							Ext.Msg.alert("提示信息","AZ端设备类型不能为空");
							return;
						}else if(infos.get("aequipmentType")==infos.get("zequipmentType")&&infos.get("alocalId")==infos.get("zlocalId")){
							Ext.Msg.alert("提示信息","相同位置点的AZ端设备类型不能相同");
							return;
						}else if(isnull(infos.get("circuitType"))){
							Ext.Msg.alert("提示信息","设备类型不能为空");
							return;
						}else{
							loadMask.show();
							var data = Ext.encode(infos.data);
							Ext.Ajax.request({
				        			url:context_path + '/bussConfigjsAction!saveCircuit.ilf',
								    success: function(response){
								    	var res = Ext.decode(response.responseText);
								    	loadMask.hide(); 
								    	if(res.success==true) {
								    		Ext.Msg.alert("提示",res.errorMsg);
		                                    maingrid.store.reload();
											win.close();
								    	} else {
								    		Ext.Msg.alert("提示",res.errorMsg);
								    	}
								    	
								    },
								    params: { data:data,activeName:activeName}
				        		});
						}
					}
					},"-",{
					text:"取&emsp;消",
//					iconCls: "delB",
					handler:function(){
						win.close();
					}
					}
				]
			});
			win.show();
			viewTopo(win);
		}

		function viewTopo(win) {
			var a_local = infos.get("alocalType");
			var z_local = infos.get("zlocalType");
			var a_local_name = infos.get("alocalName");
			var z_local_name = infos.get("zlocalName");
			var a_ne = infos.get("aequipmentType");
			var z_ne = infos.get("zequipmentType");
			var a_ne_name = infos.get("aequipmentName");
			var z_ne_name = infos.get("zequipmentName");
			var topoPanel = new Ext.Panel({
				id : "topoPanel",
				border : false,
				collapsible : false,
				closable : false,
				html : '<iframe src="' + context_path + '/jsp/resource/bussconfigjs/topo.jsp?a_local=' + a_local + '&z_local=' + z_local + '&a_local_name='
					+ a_local_name + '&z_local_name=' + z_local_name + '&a_ne=' + a_ne + '&z_ne=' + z_ne + '&a_ne_name=' + a_ne_name + '&z_ne_name=' + z_ne_name
					+ '" width="100%" height="231" border="0" frameborder="0" scrolling="no"></iframe>'
			});
			win.add(topoPanel);
			win.doLayout();
		}
	});
	function isnull(str){
		if(str==""||str=="null"||str==null||str==undefined){
			return true;
		}else{
			return false;
		}
	}
</script>
</head>
<body>
<div>
	<div id="main"></div>
	<div id="circuitData"></div>
</div>
</body>
</html>
