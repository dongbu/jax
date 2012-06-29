class Jax.Material.ShadowMap extends Jax.Material.Layer
  constructor: (options, material) ->
    super options, material
    @meshMap = vertices: 'VERTEX_POSITION'
  
  numPasses: (context) -> context.world.lights.length + 1
  
  prepare: (context, mesh, model) ->
    for i in [1...@numPasses(context)]
      light = context.world.lights[i-1]
      if light.shadows and light.shadowmap then light.shadowmap.validate context
    true
  
  setVariables: (context, mesh, model, vars, pass) ->
    vars.PASS = pass
    vars['SHADOWMAP_ENABLED'] = false
    return unless pass
    
    light = context.world.lights[pass-1]
    vars['SHADOWMAP_ENABLED'] = light.shadows && !!light.shadowmap && model.receiveShadow
    
    vars.mMatrix = context.matrix_stack.getModelMatrix()
    mesh.data.set vars, @meshMap

    if vars['SHADOWMAP_ENABLED']
      vars['ParaboloidNear'] = light.shadowmap.paraboloidNear || 1
      vars['ParaboloidFar']  = light.shadowmap.paraboloidFar  || 200
      vars['SHADOWMAP_PCF_ENABLED'] = !(@material.pcf is false)
      vars['SHADOWMAP_MATRIX'] = light.shadowmap.shadowMatrix
      vars['SHADOWMAP_WIDTH'] = light.shadowmap.width
      vars['SHADOWMAP_HEIGHT'] = light.shadowmap.height
      vars['IsDualParaboloid'] = light.shadowmap.isDualParaboloid()
      light.shadowmap.bindTextures context, vars, 'SHADOWMAP0', 'SHADOWMAP1'
