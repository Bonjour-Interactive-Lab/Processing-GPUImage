import java.nio.*;

public class VBOInterleaved {
  final static int VERT_CMP_COUNT = 4; //vertex component (x, y, z) → 4
  final static int CLR_CMP_COUNT = 4; //color componennt (r, g, b, a) → 4
  final static int UV_CMP_COUNT = 4; //color componennt (u, v, s, t) → 4
  /*define layout for interleaved VBO
   xyzwrgbaxyzwrgbaxyzwrgba...
   
   |v1       |v2       |v3       |...
   |0   |4   |8   |12  |16  |20  |...
   |xyzw|rgba|xyzw|rgba|xyzw|rgba|...
   
   stride (values per vertex) is 8 floats
   vertex offset is 0 floats (starts at the beginning of each line)
   color offset is 4 floats (starts after vertex coords)
   
   |0   |4   |8
   v1 |xyzw|rgba|
   v2 |xyzw|rgba|
   v3 |xyzw|rgba|
   |...
   */
  final int stride       = (VERT_CMP_COUNT + CLR_CMP_COUNT + UV_CMP_COUNT) * Float.BYTES; 
  final int vertexOffset =                                               0 * Float.BYTES; 
  final int colorOffset  =                                  VERT_CMP_COUNT * Float.BYTES; 
  final int uvOffset     =                (VERT_CMP_COUNT + CLR_CMP_COUNT) * Float.BYTES; 

  private int vertexCount;
  private float[] VBOi;
  private FloatBuffer attributeBuffer; 
  private int attributeVboId;

  private PGraphics graphicContext;
  private PShader shader; 

  public VBOInterleaved(PGraphics graphicContext, ArrayList<Float> attribList) {
    this.init(graphicContext, attribList);
  }

  private void init(PGraphics graphicContext, ArrayList<Float> attribList) {
    this.initElement(graphicContext);
    this.initVBO(attribList.size());
    this.setGeometry(attribList);
  }

  private void initElement(PGraphics graphicContext) {
    //init context, sahder, buffer...
    this.graphicContext = graphicContext;
    this.shader = loadShader("pfrag.glsl", "pvert.glsl");//set as param
  }

  private void initVBO(int vertexCount) {
    //init Vertex Buffer Object
    this.vertexCount = vertexCount;
    int vboSize = this.vertexCount;//(VERT_CMP_COUNT + CLR_CMP_COUNT + UV_CMP_COUNT) * this.vertexCount;

    VBOi = new float[vboSize];
    attributeBuffer = allocateDirectFloatBuffer(vboSize);

    PGL pgl = graphicContext.beginPGL();
    IntBuffer intBuffer = IntBuffer.allocate(1);
    pgl.genBuffers(1, intBuffer);
    attributeVboId = intBuffer.get(0);
    graphicContext.endPGL();
  }

  private void setGeometry(ArrayList<Float> attribList) {
    try {
      if (attribList.size() == VBOi.length) {
        for (int i=0; i<attribList.size(); i++) {
          float attribData = attribList.get(i);
          VBOi[i] = attribData;
        }
        attributeBuffer.rewind(); 
        attributeBuffer.put(VBOi); 
        attributeBuffer.rewind();
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  void display(PImage posBuffer) {
    //need to set g as param
    PGL pgl = g.beginPGL();

    shader.bind();
    shader.set("dataTexture", posBuffer);

    //send uniform to shader
    //...

    //Get attributes locations
    int vertLocation = pgl.getAttribLocation(shader.glProgram, "vertex");
    pgl.enableVertexAttribArray(vertLocation);

    int colorLocation = pgl.getAttribLocation(shader.glProgram, "color");
    pgl.enableVertexAttribArray(colorLocation);

    int uvLocation = pgl.getAttribLocation(shader.glProgram, "uv");
    pgl.enableVertexAttribArray(uvLocation);

    //Bind VBOC
    pgl.bindBuffer(PGL.ARRAY_BUFFER, attributeVboId);
    //fill with data
    pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * VBOi.length, attributeBuffer, PGL.DYNAMIC_DRAW);
    //associate current bound vbo with attributes
    pgl.vertexAttribPointer(vertLocation, VERT_CMP_COUNT, PGL.FLOAT, false, stride, vertexOffset); 
    pgl.vertexAttribPointer(colorLocation, CLR_CMP_COUNT, PGL.FLOAT, false, stride, colorOffset); 
    pgl.vertexAttribPointer(uvLocation, UV_CMP_COUNT, PGL.FLOAT, false, stride, uvOffset);
    //unbind VBO
    pgl.bindBuffer(PGL.ARRAY_BUFFER, 0); 
    
    //draw buffer
    pgl.drawArrays(PGL.POINTS, 0, vertexCount); 
    
    //disable arrays for attribute befor unbind shader
    pgl.disableVertexAttribArray(vertLocation); 
    pgl.disableVertexAttribArray(colorLocation); 
    pgl.disableVertexAttribArray(uvLocation); 
    
    //unbind Shader
    shader.unbind(); 

    g.endPGL();
  }

  //UTILS
  private FloatBuffer allocateDirectFloatBuffer(int n) {
    return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
  }
}
