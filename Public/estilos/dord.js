
function nuevaorden(idus,resul,link)
    {

 if(idus!=""){
    if (confirm('¿Esta seguro de crear la Orden')) {
      
                  // Respuesta afirmativa...
                   from(idus,resul,link);
                  }
              }
              else
              {
                 alert("no existe usuario");
              }
             //from2(idus,data,'resultorden','../Vistas/ordenes/detorden.php');
             
   
           // from('','product','../Vistas/ordenes/productos.php');

     
    }
    function nuevocliente(idus,idcli,resul,link)
    {

       var cod= document.getElementById('codidoorden').value;


      if(cod!="" && idus!=""){
        var data=""+idcli+"&id3="+cod+"";
        from2(idus,data,resul,link);
      } else
      {

        alert("Por favor crear la orden");
      }
             // 


     
    }

function agrega(idpro,nompro,pv,pc,ct)
    {

   
    if(ct>0){
              document.getElementById('codigopro').value=idpro;
              document.getElementById('nombrepro').value=nompro;
              document.getElementById('cantidadpro').value=1;
               document.getElementById('cantidadtotalpro').value=ct;
              document.getElementById('preciocomprapro').value=pc;
              document.getElementById('precioventapro').value=pv;
              document.getElementById('search').value="";
              document.getElementById('cantidadpro').focus();
              document.getElementById('totalpro').value=(1*pv);
             } else{

            
              document.getElementById('search').value="";
             document.getElementById('search').focus();
             alert("Stock Cero");
           }
            from('','product','../Vistas/ordenes/productos.php');

     
    }

function resultado1(){
  var can_prod= document.getElementById('cantidadpro').value;
  var cat_tot=document.getElementById('cantidadtotalpro').value;
  var pv=document.getElementById('precioventapro').value;
  
    if(can_prod>cat_tot ){
      alert("Cantidad maxima: "+cat_tot);
                
                 document.getElementById('cantidadpro').value=cat_tot;
                 document.getElementById('totalpro').value=(cat_tot*pv);
      
    } else 
    {
        document.getElementById('totalpro').value=(can_prod*pv);
    }

}

function resultado2(){
  var can_prod= document.getElementById('cantidadpro').value;

  var pv=document.getElementById('precioventapro').value;
  var pc=document.getElementById('preciocomprapro').value;
       if(pc>pv){

          alert("Precio Minimo: "+pc);
                  document.getElementById('precioventapro').value=pc;
                  document.getElementById('totalpro').value=(can_prod*pc);
        
      } else
      {
          document.getElementById('totalpro').value=(can_prod*pv);
      }


 

}

function guardar(idus)
    {
 
    var cod= document.getElementById('codidoorden').value;


    if(cod!="" && idus!=""){
             var codprod= document.getElementById('codigopro').value;
             var can_prod= document.getElementById('cantidadpro').value;
             var pv=document.getElementById('precioventapro').value;
             var pc=document.getElementById('preciocomprapro').value;
             //alert("codigo"+cod+idus);
             var data=""+cod+"&id3="+codprod+"&id4="+can_prod+"&id5="+pv+"&id6="+pc+"";
             //alert("codigo"+data);
             from2(idus,data,'resultorden','../Vistas/ordenes/detorden.php');
             } else{

            
              
             alert("seleccione cliente ");
           }
            //from('','product','../Vistas/ordenes/productos.php');

     
    }
function actualizar(idus)
    {
 
    var cod= document.getElementById('codidoorden').value;


    if(cod!="" && idus!=""){
           
             var data=""+cod+"";
             //alert("codigo"+data);
             from2(idus,data,'resultorden','../Vistas/ordenes/detorden.php');
             } else{

            
              
             alert('No exite La orden');
           }
            //from('','product','../Vistas/ordenes/productos.php');

     
    }
    function inprimir(idus)
    {
 
    var cod= document.getElementById('codidoorden').value;


    if(cod!="" && idus!=""){
           
             var data=""+cod+"";
             alert("imprimir"+data);
             //from2(idus,data,'resultorden','../Vistas/ordenes/detorden.php');
             } else{

            
              
             alert('No exite La orden');
           }
            //from('','product','../Vistas/ordenes/productos.php');

     
    }

     function eliminarord(idus)
    {
 
    var cod= document.getElementById('codidoorden').value;


    if(cod!="" && idus!=""){
           if (confirm('¿Seguro de Elininar')) {

             var data=""+idus+"&id3="+1+"&id4="+4;    
             from2(cod,data,'resultorden','../Vistas/ordenes/editadetalle.php');
            location.href = "../registrarOrden/";
              }
             } else{

            
              
             alert('No exite La orden');
           }
            //from('','product','../Vistas/ordenes/productos.php');

     
    }

   function proforma(idus)
    {
 
    var cod= document.getElementById('codidoorden').value;


    if(cod!="" && idus!=""){
           if (confirm('¿Seguro de guardar como factura')) {

             var data=""+idus+"&id3="+1+"&id4="+4;    
             from2(cod,data,'resultorden','../Vistas/ordenes/editadetalle.php');
            location.href = "../registrarOrden/";
              }
             } else{

            
              
             alert('No exite La orden');
           }
            //from('','product','../Vistas/ordenes/productos.php');

     
    }
     function eliminardetalle(iddetord)
    {
 
    var cod= document.getElementById('codidoorden').value;


    if(cod!="" && iddetord!=""){
           
            
            
             if (confirm('¿Seguro de Elininar')) {
                
            
               var data=""+iddetord+"&id3="+1+"&id4="+3;    
             from2(cod,data,'resultorden','../Vistas/ordenes/editadetalle.php');
                  alert('eliminado');
               //var data=""+iddetord+"&id3="+can+"&id4="+op;    
             //from2(cod,data,'resultorden','../Vistas/ordenes/editadetalle.php');
                  }
            
             } else{

            
              
             alert('No exite La orden');
           }
           
     
    }


    function editar(resul,iddetord,can,op)
    {
 
    var cod= document.getElementById('codidoorden').value;


    if(cod!="" && iddetord!=""){
           
             
            
               var data=""+iddetord+"&id3="+can+"&id4="+op;    
             from2(cod,data,'resultorden','../Vistas/ordenes/editadetalle.php');


            
             } else{

            
              
             alert('No exite La orden');
           }/*

            var cantidad= document.getElementById('canti'+iddetord).value;
               var precio= document.getElementById('preci'+iddetord).value;
              
             document.getElementById('ipor'+iddetord).innerHTML=cantidad*precio;*/
          
          
    }

     
    
   
  
