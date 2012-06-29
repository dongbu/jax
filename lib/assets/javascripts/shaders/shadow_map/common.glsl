//= require "shaders/lib/lights"

shared uniform int PASS;
shared uniform mat4 mMatrix, pMatrix;

shared uniform bool IsDualParaboloid;
shared uniform bool SHADOWMAP_ENABLED;
shared uniform sampler2D SHADOWMAP0, SHADOWMAP1;
shared uniform mat4 SHADOWMAP_MATRIX;
shared uniform bool SHADOWMAP_PCF_ENABLED;
shared uniform float ParaboloidNear, ParaboloidFar;
shared uniform float SHADOWMAP_WIDTH, SHADOWMAP_HEIGHT;

shared varying vec4 vShadowCoord;
