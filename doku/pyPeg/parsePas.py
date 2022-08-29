import enum
from lib2to3.pgen2 import grammar
import string,os
from pypeg2 import *

my_file = os.path.realpath(__file__) # Welcher File wird gerade durchlaufen
my_dir = os.path.dirname(my_file)
projekt_dir = os.path.normpath(os.path. os.path.join(my_dir, '..', '..'))

############################### Keywords ################################
class Section(Keyword):
    grammar = Enum( K("unit"), K("interface"), K("implementation"), K("end") )

class Interface_Keys(Keyword):
    grammar = Enum( K("uses"), K("type") )

class Type_Keys(Keyword):
    grammar = Enum( K("class"), K("record"), K("array") )

############################### special Lines ################################
class CodeLine(str):
    #  grammar = -2,word, ";",endl
     grammar = restline

class CodeLines(List):
     grammar = maybe_some(CodeLine)

class DokString(str):
     grammar = "///", restline
     
class DokStrings(List):
     grammar = maybe_some(DokString)
     

class End(str):
    grammar = "end."

class Comment(str):
    # grammar =  "//",re.compile('[.^/]'),restline
    grammar =  "//",restline


############################### Classes ans members ################################

class Function(List):
     grammar = "function", name()
            #  "(", attr("parms", Parameters), ")", block 

class VarDekl(List):
    grammar =  attr('Dok',DokStrings),ignore(maybe_some(Comment)), name(), ":", attr("Typ", Symbol) ,";"

#directives einer Methode
class Directives(List):
    #^(?!end) ^Auswerten am Anfang eines Strings ?! negativ lookahead alles ausser end
    grammar =  maybe_some(re.compile('^(?!end)\w*'),";")

#Liste von Parametern fuer Prozedur oder Funktion
class Parameter(List):
    grammar =  name(), ":", attr("Typ", Symbol),ignore(optional(";"))

class ParamListe(List):
    grammar =  optional("(",maybe_some(attr("par", Parameter)),")")

#Deklaration einer Prozedur
class ProcDekl(List):
    grammar =  attr('Dok',DokStrings),ignore(maybe_some(Comment)),"procedure", name(),attr("Parameter",ParamListe),";",Directives

class Klasse(List):
    grammar =  attr('Dok',DokStrings), name(), "=","class",optional("(",optional(attr("Ahne", Symbol)),")"), \
        maybe_some(VarDekl),maybe_some(ProcDekl), optional("end"),";"
        # maybe_some(attr('Var',VarDekl)), maybe_some(Comment), optional("end"),";"
        
class Klassen(List):
    grammar =  maybe_some(Klasse)

############################### type definitions ################################

class Typ_Statements(List):
    grammar = "type",attr("Klassen",Klasse)

############################### Unit and toplevel sections ################################
class Use(str):
    grammar = re.compile('[\w\.]*')

class Uses(List):
    grammar = "uses",csl(Use),";"

class Interface(List):
    grammar = "interface",attr("uses", Uses),maybe_some(Typ_Statements)
        
class Implementation(str):
    grammar = CodeLines,attr("section", Section)

class Unit(List):
    grammar = attr('Dok',DokStrings),attr("section", Section),name(),";"

class All(List):
    grammar =  attr("unit", Unit),attr("interface", Interface),End
 
 ############################### Ablauf ################################
def handle_file(fname):
    pas_file = os.path.join(projekt_dir, fname )
    with open(pas_file,mode='r', encoding='utf-8') as f:
        # text = f.read().strip()
        text = f.read()
    slash_pos = text.find('//')
    text= text[1:]
    # text = "procedure KaAuswerten(KaId:string);"
    # erg = parse(text,Typ_Statements)
    erg = parse(text,All)
    IF = erg.interface[1].Klassen
    print(erg.unit.name)
    pass

fname = 'XAuswerten.pas'
handle_file(fname)
pass