PImage carte;
Table pos;
int lignes;
Table fans;
Table maison;
PFont font;
float taille;
float valeur;
float dmin = MAX_FLOAT;
float dmax = MIN_FLOAT;
float dminMaison = 1.0;
float dmaxMaison;
Integrator[] interp;

void setup() {

   //size(640, 900);
   fullScreen(P3D);
   font = createFont("Helvetica-12.vlw", 20);
   textFont(font);
   
    carte = loadImage("togo.jpg");
    pos = new Table("position.tsv");
    lignes = pos.getRowCount();
    fans = new Table("fans.tsv");
    maison = new Table("maison.tsv");
    dmaxMaison= maison.getRowCount();

    trouverMinMax(fans);
   interp = new Integrator[lignes];

   for(int ligne = 0; ligne < lignes; ligne++) {
    interp[ligne] = new Integrator(fans.getFloat(ligne, 1));

    }
    randomFansMaison();

}
void draw() {   
    background(255);
    image(carte, 0, 0);
    representerFanMaison();

    smooth();
    noStroke();
        fill(14, 173, 44);
       text("Légende des maison de Game of Throne : ",width/2, height/6);
       
       fill(192, 0, 0);
       ellipse(width/2.,height/4.,15.,15.); 
       text("Maison 1 (Barathéon)",width/1.9, height/4); 

       fill( 193,14,122);
       ellipse(width/2.,height/3.5,15.,15.); 
       text("Maison 2 (Targaryen) ",width/1.9, height/3.5); 

       fill( 111,55,173);
       ellipse(width/2.,height/3.,15.,15.);  
       text("Maison 3 (Stark) ",width/1.9, height/3.); 

       fill(14,44,227);
       ellipse(width/2.,height/2.7,15.,15.);
       text("Maison 4 (Lannister) ",width/1.9, height/2.7); 
       fill(14,0,0);
       text("NB : La taille des éllipses varient en fonction du nombre de fans.\n\t Plus le nombre de fans est élevé la taille des ellipses augmentent. ",width/2., height/2.2); 


 }
void fansTaille(float x, float y,int ligne) {
       valeur = interp[ligne].value;
    // On transforme la valeur de son intervalle de définition vers l'intervalle [2,40].
    // La fonction map est prédéfinie par Processing.
      taille = map(valeur, dmin, dmax, 10, 80);
    // Enfin on dessine une ellipse dont la taille varie en fonction de la valeur.
    ellipse(x, y, taille, taille);           

}  

void trouverMinMax(Table table) {
    for(int ligne = 0; ligne < lignes; ligne++) {
        float valeur = table.getFloat(ligne, 1);
        if(valeur > dmax) dmax = valeur;
        if(valeur < dmin) dmin = valeur;
    }
}

void randomFansMaison() {
    for(int ligne = 0; ligne < lignes; ligne++) {
        float nouvValMaison = random(dminMaison, dmaxMaison);
        maison.setFloat(ligne, 1, nouvValMaison);
        
        float nouvValFans = (int)random(dmin, dmax);
        fans.setFloat(ligne, 1, nouvValFans);
        interp[ligne].target((int)random(dmin, dmax));

    }
}
void keyPressed() {
        randomFansMaison();
}
void representerFanMaison(){
     for(int ligne = 0; ligne < lignes; ligne++) {
        // La clé nous sera utile pour retrouver les valeurs dans l'autre
        // ensemble de données.
        interp[ligne].update();
        String cle = maison.getRowName(ligne);
        String cle2 = fans.getRowName(ligne);
        
        float x = pos.getFloat(cle2, 1);
        float y = pos.getFloat(cle2, 2);
        fill(lerpColor(#FF4422, #4422CC, norm(maison.getFloat(cle, 1),(int) dminMaison, (int)dmaxMaison)));// Couleur pour indiqué les maison
        fansTaille(x, y,ligne);// taille des ellipses pour indiqué les fans
        informations(x, y, ligne,cle,cle2);
    }
}      

void informations(float x, float y, int ligne,String cle,String cle2) {
  float fan = interp[ligne].value;
  float maiso = maison.getFloat(cle2, 1);
  String nomMaison = null;
  
  if (dist( mouseX, mouseY,x,y)<taille/2 && dist(mouseX, mouseY,x,y)<taille/2)
  {
   switch((int)maiso){
    case  1 : nomMaison = "Barathéon";
        break;
    case  2 : nomMaison = "Targaryen";
        break;
    case  3 : nomMaison = "Stark";
        break;
    case  4 : nomMaison = "Lannister";
        break;

    
  }
   text("Region : "+cle+"\n"+"Coordonnées(x = "+x+", y= "+y+")\n"+"Nombre de fans : "+(int)fan+"\n"+"Maison preferés : "+(int)maiso+" ("+nomMaison+")\n",x, y); 

  }

}
