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
                                      <?php 
                                        $detord = new detOrdenes();
                                         $result=$detord->get_alliddetordenes($idord);
                                         while($lista=$result->fetch_array()){                        
                                             ?>
                                      <tr>

                                          <td><input  class="form-control" value="<?php echo $lista['PRO_D_NOMBRE'] ?>"></td>
                                          
                                            <td><div id="can<?php echo $lista['DTL_C_CODIGO'] ?>"><input type="text" id="canti<?php echo $lista['DTL_C_CODIGO'] ?>" class="form-control" onkeyup="if(event.keyCode == 13) editar('can<?php echo $lista['DTL_C_CODIGO'] ?>',<?php echo $lista['DTL_C_CODIGO'] ?>,this.value,1)" value="<?php echo $lista['DTL_N_CANTIDAD'] ?>"></div></td>
                                            <td><div id="pre<?php echo $lista['DTL_C_CODIGO'] ?>"><input type="text" id="preci<?php echo $lista['DTL_C_CODIGO'] ?>"   class="form-control" onkeyup="if(event.keyCode == 13) editar('pre<?php echo $lista['DTL_C_CODIGO'] ?>',<?php echo $lista['DTL_C_CODIGO'] ?>,this.value,2)" value="<?php echo $lista['DTL_N_PRECIOVENTA'] ?>"></div></td>
                                            <td><input  class="form-control" value="<?php echo $lista['DTL_N_IMPORTE'] ?>"></td>
                                          
                                          <td>
                                          </td>
                                          <td><button class="btn btn-danger btn-xs" onclick="eliminardetalle(<?php echo $lista['DTL_C_CODIGO'];?>)"><i class="fa fa-trash"></i></button>
                                          </td>
                                      </tr>
                                      <?php 
                                      $total=$total+$lista['DTL_N_IMPORTE'];

                                      } ?>
                                      <tr>
                                         <td colspan="6"><hr></td>
                                         
                                      </tr>
                                      <tr>
                                         <td colspan="2"></td>
                                         <td>SUB_TOTAL</td>
                                         <td><label><?php echo round(($total/1.18),2); ?></label></td>
                                         <td></td>
                                      </tr>
                                      <tr>
                                         <td colspan="2"></td>
                                         <td>IGV</td>
                                         <td><label><?php echo round($total-($total/1.18),2);?></label></td>
                                         <td></td>
                                      </tr>
                                      <tr>
                                         <td colspan="2"></td>
                                         <td>TOTAL</td>
                                         <td><label><?php echo round($total,2);?></label></td>
                                         <td></td>
                                      </tr>
                                    </tbody>
                                </table>

