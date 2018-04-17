nuevaordern.php
<?php include_once(HTML_DIR . '/template/titulo.php'); ?>
<?php include_once(HTML_DIR . '/template/links.php'); ?>
<?php include_once(HTML_DIR . '/template/header_menu.php'); ?>

  <div class="content-wrapper" >
    <div class="content">
     
    
      <div class="box">
        <div class="box-header with-border">
          <center> <h2>ORDEN DE COMPRA</h2></center>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="Collapse">
              <i class="fa fa-minus"></i></button>
            <button type="button" class="btn btn-box-tool" data-widget="remove" data-toggle="tooltip" title="Remove">
              <i class="fa fa-times"></i></button>
          </div>
        </div>
        <div class="box-body">
          
          <div class="col-md-12">
                      
          <!-- general form elements disabled -->
       
           <div class="" >
            <div  >
                <div class="col-md-8">
                  <div class="panel panel-default">
                    <div class="panel-heading"> Dotos del cliente:
                      <div class="box-tools pull-right">
                        <button type="button" class="btn btn-success btn-xs " data-toggle="modal" 
                         data-target="#agregarclientes"><i class=" fa fa-user-plus"></i> Agregar</button>
                      </div>
                      </div>
                       <div class="panel-body " id="resultclientes" >
                          <div class="col-md-8">
                            Nombre o Razon Social:.............
                          </div>
                           <div class="col-md-4">
                           Ruc:...............................
                          </div>
                          <div class="col-md-8">
                           Dirección:....................................
                          </div>

                        
                      </div>
                  </div>
                </div>
                <div class="col-md-4">
                  <div class="panel panel-default">
                     <div class="panel-heading"> 
                        Orden De Compra Numero:
                         <div class="box-tools pull-right">
                        <button type="button" class="btn btn-success btn-xs " onclick="nuevaorden(<?php echo $usuario['US_C_CODIGO'];?>,'numeroorden','../Vistas/ordenes/orden.php')"><i class=" fa fa-user-plus"></i> Nueva Orden</button>
                      </div>
                     </div>
                     <div class="panel-body " id="numeroorden">
                      
                      <div class="col-md-12">
                        <label>Nº : 0000000000</label>
                        <input type="hidden" id="codidoorden" value="">
                      </div>
                      
                     </div>
                  </div>
                </div>
            </div>
            <div >
              <div class="col-md-12">
                  <div class="panel panel-default">
                       <div class="panel-heading"> 
                         Detalle de la  Orden De Compra:
                         <div class="box-tools pull-right">
                          <button type="button" class="btn btn-primary btn-xs" data-toggle="modal" 
                            data-target="#agregarproductos"><i class=" fa  fa-list"></i> Productos</button>
                         </div>
                       </div>
                       <div class="panel-body ">
                            <div class="col-md-12">
                              <button  class="btn btn-primary btn-xs" 
                               onclick="actualizar(<?php echo $usuario['US_C_CODIGO']?>)"><i class=" fa  fa-list" ></i> Actualizar</button>
                              <div id="resultorden">
                                <table  class="" width="100%">
                                    <thead>
                                       <tr>
                                          <th>NOMBRE</th>
                                          <th>CANTIDAD</th>
                                          <th>P VENTA</th>
                                          <th>SUB_TOTAL</th>
                                          <th colspan="2" class="col-md-2">Opciones
                                          </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                      <tr>
                                         <td colspan="6"><hr></td>
                                         
                                      </tr>
                                      <tr>
                                         <td colspan="2"></td>
                                         <td>SUB_TOTAL</td>
                                         <td>00</td>
                                         <td></td>
                                      </tr>
                                      <tr>
                                         <td colspan="2"></td>
                                         <td>IGV</td>
                                         <td>00</td>
                                         <td></td>
                                      </tr>
                                      <tr>
                                         <td colspan="2"></td>
                                         <td>TOTAL</td>
                                         <td>00</td>
                                         <td></td>
                                      </tr>
                                    </tbody>
                                </table>
                              </div>
                            </div>                
                       </div>
                  </div>
              </div>
              <div class="col-md-12">
                  <div class="panel panel-default">
                       <div class="panel-heading"> 
                         Opciones De Orden:
                         <div class="box-tools pull-right">
                          <button  class="btn btn-primary btn-xs" 
                                            onclick="inprimir(<?php echo $usuario['US_C_CODIGO']?>)"><i class=" fa  fa-list" ></i> PROFORMA</button>
                          <button  class="btn btn-primary btn-xs" 
                                            onclick="inprimir(<?php echo $usuario['US_C_CODIGO']?>)"><i class=" fa  fa-list" ></i> BOLETA</button>
                          <button  class="btn btn-primary btn-xs" 
                                            onclick="inprimir(<?php echo $usuario['US_C_CODIGO']?>)"><i class=" fa  fa-list" ></i> FACTURA</button>
                          <button  class="btn btn-primary btn-xs" 
                                            onclick="inprimir(<?php echo $usuario['US_C_CODIGO']?>)"><i class=" fa  fa-list" ></i> IMPRIMIR</button>
                          <button  class="btn btn-primary btn-xs" 
                                            onclick="eliminarord(<?php echo $usuario['US_C_CODIGO']?>)"><i class=" fa  fa-list" ></i>ELIMINAR</button>
                          <button  class="btn btn-primary btn-xs" 
                                           onclick="actualizar(<?php echo $usuario['US_C_CODIGO']?>)"><i class=" fa  fa-list" ></i>ACTUALIZAR</button>
                          
                         </div>
                       </div>
                       
                  </div>
              </div>
            </div>
        </div>
          
          <!-- /.box -->
      </div>
    </div>
  </div>

   
<div class="modal fade" id="agregarclientes" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Agregar Cliente</h4>
      </div>
      <div class="modal-body">
        <form action=""  >
          <div class="input-group col-md-8">
          <input type="text" name="q" class="form-control" placeholder="Search..." onkeyup="from2(<?php echo $usuario['US_C_CODIGO']?>,this.value,'client','../Vistas/ordenes/clientes.php')">
              <span class="input-group-btn">
                <a   class="btn btn-success btn-flat"><i class="fa fa-search"></i>
                </a>
              </span>
        </div>
          
           <div class="form-group" id="client">
           <table  class="table table-hover">
                <thead>
                <tr>
                  <th>NOMBRE</th>
                  <th>APELLIDOS</th>
                  <th>DIRECCION</th>
                   <th>RUC o DNI</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
          </div>
          
        </div>
      </form>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
               
      </div>
      
    </div> 
  </div>
</div>




<div class="modal fade" id="agregarproductos" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Buscar Productos</h4>
      </div>
      <div class="modal-body">
        <form id="form_prod"  method="post">
              <div class="col-md-12">
                   <div class="form-group col-md-4">
                    <input type="hidden" name="codigopro" id="codigopro" class="form-control" placeholder="Nombre Porducto" >
                    <input type="text" name="nombrepro" id="nombrepro" class="form-control" placeholder="Nombre Porducto" disabled>
                   </div>
                   <div class="form-group col-md-2">
                     <input type="hidden" name="cantidadtotalpro" id="cantidadtotalpro"  class="form-control" placeholder="0" >
                     <input type="text" name="cantidadpro" id="cantidadpro" onkeyup="if(event.keyCode == 13) resultado1()" class="form-control" placeholder="0" >  
                  </div>
                  <div class="form-group col-md-2">
                    <input type="hidden" name="preciocomprapro" id="preciocomprapro" class="form-control"  >
                    <input type="text" name="precioventapro" id="precioventapro" onkeyup="if(event.keyCode == 13) resultado2()" class="form-control" placeholder="00" >  
                  </div>
                  <div class="form-group col-md-2">
                     <input type="text" name="totalpro" id="totalpro" class="form-control" placeholder="00" > 
                  </div>
                  <div class="form-group col-md-2">
                    <button type="button" class="btn btn-warning"  onclick="guardar(<?php echo $usuario['US_C_CODIGO']?>)" data-dismiss="modal" ><i class="fa fa-save"></i> Ok</button>
                  </div>
              </div>
              <div class="col-md-12">
                  <div class="input-group col-md-8">
                  <input type="text" name="search" class="form-control" id="search" placeholder="Search..." onkeyup="from(this.value,'product','../Vistas/ordenes/productos.php')">
                      <span class="input-group-btn">
                        <a   class="btn btn-success btn-flat"><i class="fa fa-search"></i>
                        </a>
                      </span>
                  </div>
            
              </div>
              <div class="form-group" id="product">
               
             </div>
          
        
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
      
      </div> 
    </div>
  </div>
</div> 

<div class="modal fade" id="editarproductos" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Editar Productos</h4>
      </div>
      <div class="modal-body">
        <form id="form_prod"  method="post">
              <div class="col-md-12">
                   <div class="form-group col-md-4">
                    <input type="hidden" name="ecodigopro" id="ecodigopro" class="form-control" placeholder="Nombre Porducto" >
                    <input type="text" name="enombrepro" id="enombrepro" class="form-control" placeholder="Nombre Porducto" disabled>
                   </div>
                   <div class="form-group col-md-2">
                     <input type="hidden" name="ecantidadtotalpro" id="ecantidadtotalpro"  class="form-control" placeholder="0" >
                     <input type="text" name="ecantidadpro" id="ecantidadpro" onkeyup="if(event.keyCode == 13) resultado1()" class="form-control" placeholder="0" >  
                  </div>
                  <div class="form-group col-md-2">
                    <input type="hidden" name="epreciocomprapro" id="epreciocomprapro" class="form-control"  >
                    <input type="text" name="eprecioventapro" id="eprecioventapro" onkeyup="if(event.keyCode == 13) resultado2()" class="form-control" placeholder="00" >  
                  </div>
                  <div class="form-group col-md-2">
                     <input type="text" name="etotalpro" id="etotalpro" class="form-control" placeholder="00" > 
                  </div>
                  <div class="form-group col-md-2">
                    <button type="button" class="btn btn-warning"  onclick="actualzardetalle(<?php echo $usuario['US_C_CODIGO']?>)" data-dismiss="modal" ><i class="fa fa-save"></i> Ok</button>
                  </div>
              </div>
              
          
        
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
      
      </div> 
    </div>
  </div>
</div>
</div>
 <?php include_once(HTML_DIR . '/template/footer.php'); ?>
<?php include_once(HTML_DIR . '/template/ajustes_generales.php'); ?>
<?php include_once(HTML_DIR . '/template/scrips.php'); ?>
<script src="../Public/estilos/dord.js"></script>

<?php include_once(HTML_DIR . '/template/inferior_depues_cuerpo.php'); ?>