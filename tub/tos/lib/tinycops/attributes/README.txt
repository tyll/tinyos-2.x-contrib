TinyCOPS attribute semantics are defined in the "attributes.xml" file in this
directory. The attributes.xml file has an XML section <ps_attribute> ...
</ps_attribute> for each attribute, containing the following XML tags:

attribute_name: Short textual label
attribute_description: Textual description of the attribute (or e.g. hyperlink)
attribute_type: Data type of the value {String, int8, uint8, int16, uint16, int32, uint32}; 
attribute_min: Minimum value (for String/array = minimum length)
attribute_max: Maximum value (for String/array = maximum length)
ps_metric: A subsection for the metric of the value (e.g. degree celsius)
metric_conversion: Conversion formula, in which "X" represents the value {X,+,-,*,/,FLOAT,(,)}* 
attribute_endianness: Endianness of the value {big, little}
attribute_component: nesC component implementing the attribute
attribute_preferred_visualization: Preferred graphical representation {number, graph, text, none}
ps_operation: A subsection per allowed operation on the attribute
operation_name: Short symbolic representation of the operation (e.g. "<", ">")
operation_description: Description of the operation

Each attribute is assigned a globally unique integral identifier (attribute ID)
as an XML attribute "id", which is part of the <ps_attribute> tag, e.g.
<ps_attribute id="17">. Operation IDs are unique only within the scope of an
attribute definition, i.e.  different attributes may assign different
operations to the same operation ID.  An operation ID is expressend as an XML
attribute "id" as part of the <ps_operation> tag.  All IDs are a non-negative
integral number. 

Per attribute there can be any number of ps_metric subsections (if only the "raw"
data is used then there is no such subsection).  Each metric subsection is
defined by the <ps_metric> tag which has an XML attribute "name" that is a
short textual description of the metric.  There is one tag <metric_conversion>
inside the subsection which includes the conversion formula to convert the raw
value to the desired metric.  Inside the formula the raw value is represented
by "X". The formula may also consist of:
 - basic arithmetric operators: +,-,*,/
 - brackets: (,) 
 - float constants: e.g. "10.25"
 - functions "sin()", "cos()", "exp()", "ln()", "log()" and predefined
   constants such as "pi" or "e". For a complete list see
http://www.singularsys.com/jep/doc/html/op_and_func.html.

An attribute entry MUST define the following three elements: attribute_name,
attribute_description and attribute_type, all other elements are optional. To
check if the attributes.xml is valid enter: 

$ xmllint --valid --noout attributes.xml

(If you see no output, everything is fine.)

