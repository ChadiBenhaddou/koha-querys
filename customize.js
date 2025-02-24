if (window.location.href.substring(24) === "/cgi-bin/koha/serials/subscription-add.pl") {
   document.querySelector('#serialsadditems-yes').click();
  var elementsWithClass = document.querySelectorAll('.use_items');
    if (elementsWithClass) {
        elementsWithClass.forEach(function(element) {
            element.style.display = 'flex';
        });
    }
    document.querySelector('#branchcode').value = "BC";
     document.querySelector('#itemtype').value = "PER"; 
}




//***************************************AUTOMATISATION DE CREATION DES ZONES***************************************

//AUTOMATISATION DE LA VALEUR DE LA SOUS-ZONE b DE LA ZONE 040
//----------------------START / 040----------------------
// Wait for the document to be fully loaded
$(document).ready(function() {
    // Function to update subfield b based on the value of the 008 field
    function updateSubfieldB() {
        // Extract the value of the 008 field from the input field (assuming it has an ID of 'field008')
        var fieldValue = $("[id^='tag_008_subfield_00']").val();

        // Extract the language code from the 008 field value (assuming it's at a fixed position)
        //var languageCode = fieldValue.substring(35, 38); // Adjust the indices as needed

      	if (fieldValue && fieldValue.length >= 38) {
    	var languageCode = fieldValue.substring(35, 38);
		} else {
    	console.error('fieldValue is either undefined or too short:', fieldValue);
		}

		if(languageCode === 'ara'){
        // Update the value of subfield b in field 040 as following : ('FRAS|bfre|cFRAS|dFRAS|eAFNOR')
        $("[id^='tag_040_subfield_a']").val("FRAS");
		$("[id^='tag_040_subfield_b']").val(languageCode);
		$("[id^='tag_040_subfield_c']").val("FRAS");
		$("[id^='tag_040_subfield_d']").val("FRAS");
		$("[id^='tag_040_subfield_e']").val("AFNOR");
		}else if(languageCode === 'fre'){
		$("[id^='tag_040_subfield_a']").val("FRAS");
		$("[id^='tag_040_subfield_b']").val(languageCode);
		$("[id^='tag_040_subfield_c']").val("FRAS");
		$("[id^='tag_040_subfield_d']").val("FRAS");
		$("[id^='tag_040_subfield_e']").val("AFNOR");
		}else if(languageCode === 'eng'){
		$("[id^='tag_040_subfield_a']").val("FRAS");
		$("[id^='tag_040_subfield_b']").val("fre");
		$("[id^='tag_040_subfield_c']").val("FRAS");
		$("[id^='tag_040_subfield_d']").val("FRAS");
		$("[id^='tag_040_subfield_e']").val("AFNOR");
		}else{
		$("[id^='tag_040_subfield_c']").val("FRAS");
		}
      
    }

    // Call the function to update subfield b when various events occur on the 008 field
    $("[id^='tag']").on('input change blur mouseleave', function() {
        updateSubfieldB();
    });
});
//----------------------END / 040----------------------


//AUTOMATISATION DE LA VALEUR DE LA SOUS-ZONE b DE LA ZONE 072
//----------------------START / 072----------------------
// Wait for the document to be fully loaded
$(document).ready(function() {
    // Function to update subfield a of field 072 based on the value of the 040 and 650 fields
    function updateSubfieldB_072() {
        // Extract the value of the 040 and 650 fields from the input field
        var fieldValue_072 = $("[id^='tag_072_subfield_a']").val();
		
		var fieldValue_040_a = $("[id^='tag_040_subfield_a']").val();
		var fieldValue_040_b = $("[id^='tag_040_subfield_b']").val();
		var fieldValue_040_c = $("[id^='tag_040_subfield_c']").val();
		var fieldValue_040_d = $("[id^='tag_040_subfield_d']").val();
		var fieldValue_040_e = $("[id^='tag_040_subfield_e']").val();
		
		var fieldValue_94_a = $("[id^='tag_094_subfield_a']").val();
		//var lenght_fieldValue_650_a = $("[id^='tag_650_subfield_a']").val().length;
		
		
      	// Select the element
var fieldValueElement = $("[id^='tag_650_subfield_a']");

// Check if the element exists and has a value
if (fieldValueElement.length > 0) {
    var fieldValue = fieldValueElement.val();
    
    // Ensure the value is not undefined or null
    if (fieldValue !== undefined && fieldValue !== null) {
        var lenght_fieldValue_650_a = fieldValue.length;
        console.log('Length of fieldValue:', lenght_fieldValue_650_a);
    } else {
        console.error("The element has no value:", fieldValueElement);
    }
} else {
    console.error("No element found with the selector [id^='tag_650_subfield_a']");
}

        
      
      
		if(fieldValue_040_a != "ELECTRE" && fieldValue_040_b != "ELECTRE" && fieldValue_040_c != "ELECTRE" && fieldValue_040_d != "ELECTRE" && fieldValue_040_e != "ELECTRE" && (fieldValue_94_a === "PI" || lenght_fieldValue_650_a>0)){
						
			$("[id^='tag_072_subfield_a']").val("OM");
		}
    }

    // Call the function to update the field when various events occur on any field
    $("[id^='tag']").on('input change blur mouseleave', function() {
        updateSubfieldB_072();
    });
});
//----------------------END / 072----------------------


//AUTOMATISATION DE LA VALEUR DE LA SOUS-ZONE b DE LA ZONE 049
//----------------------START / 049----------------------
$(document).ready(function() {
    // Function to update subfield $a of field 049 based on the value and indicator of the 041 field 
    function updateSubfieldB_049() {
        // Get the element for 041 subfield h and check if it exists and has a value
        var fieldValue_041_h = $("[id^='tag_041_subfield_h']").val();
        var field_041_indicator_1 = $("input[name^='tag_041_indicator1']").val();

        // Only proceed if the field exists and has a value
        if (fieldValue_041_h !== undefined && fieldValue_041_h !== null && fieldValue_041_h.length > 0) {
            // Check if the indicator is '1' and if the $h subfield has a value
            if (field_041_indicator_1 == 1) {
                // Set the value of 049 subfield a to "Trad"
                $("[id^='tag_049_subfield_a']").val("Trad");
            }
        } else {
            console.warn("tag_041_subfield_h is undefined or empty.");
        }
    }

    // Call the function to update the field when various events occur on any field
    $("[id^='tag']").on('input change blur mouseleave', function() {
        updateSubfieldB_049();
    });
});

//----------------------END / 049----------------------


//AUTOMATISATION DE LA VALEUR DE LA SOUS-ZONE b DE LA ZONE 095
//----------------------START / 095----------------------
$(document).ready(function() {
    // Function to update subfield b based on the value of the 008 field
    function updateSubfieldB_095() {
        // Extract the value of the 008 field (ensure the element exists before using its value)
        var fieldValue_008 = $("[id^='tag_008_subfield_00']").val();

        // Check if fieldValue_008 exists and has a length before trying to use substring
        if (fieldValue_008 && fieldValue_008.length >= 18) {
            // Extract the language code from the 008 field value (fixed position)
            var languageCode_008 = fieldValue_008.substring(15, 18).trim(); // Adjust the indices as needed

            // Update the value of subfield $a in field 095 based on language code conditions
            if (languageCode_008 !== '   ' && languageCode_008 !== '|||') {
                $("[id^='tag_095_subfield_a']").val(languageCode_008);
            } else {
                $("[id^='tag_095_subfield_a']").val("");
            }
        } else {
            console.warn("fieldValue_008 is undefined or too short.");
            // Optionally, you can clear the value if the field is missing or invalid
            $("[id^='tag_095_subfield_a']").val("");
        }
    }

    // Call the function to update subfield b when various events occur on any field
    $("[id^='tag']").on('input change blur mouseleave', function() {
        updateSubfieldB_095();
    });
});

//----------------------END / 095----------------------
//MODUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUULE
//--------Module------------------------
document.addEventListener('DOMContentLoaded', function() {
    // Select the parent <ul> element
    var targetUl = document.querySelector('.biglinks-list');
    
    if (targetUl) {
        // Get the current hostname or IP address of the server
        var serverAddress = window.location.hostname;

        // Create a new <li> element
        var newLi = document.createElement('li');
        
        // Set the inner HTML of the new <li> element with the dynamic server address
        newLi.innerHTML = '<a class="icon_general icon_suggestion" target="_blank" href="http://' + serverAddress + '"><i class="fa fa-fw fa-list-ul"></i>Module de suggestion</a>';
        
        // Append the new <li> element to the target <ul>
        targetUl.appendChild(newLi);
    } else {
        console.error('Target element not found.');
    }
});
//MODUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUULE

// Remove "search catalog" reserve
document.addEventListener("DOMContentLoaded", function() {
    // Remove the "recherche catalogage" menu item
    var rechercheCatalogageLink = document.querySelector('li a[title="Recherche catalogage"]');

    // Check if the link exists before trying to access parentElement
    if (rechercheCatalogageLink) {
        var rechercheCatalogage = rechercheCatalogageLink.parentElement;
        if (rechercheCatalogage) {
            rechercheCatalogage.parentNode.removeChild(rechercheCatalogage);
        }
    } else {
        console.warn('L\'élément avec le titre "Recherche catalogage" n\'a pas été trouvé.');
    }

    // Set "Recherche catalogue" as the default selected item
    var rechercheCatalogueLink = document.querySelector('li a[title="Recherche catalogue"]');
    if (rechercheCatalogueLink) {
        var rechercheCatalogue = rechercheCatalogueLink.parentElement;
        rechercheCatalogue.classList.add("active");
        rechercheCatalogueLink.setAttribute("aria-expanded", "true");
    } else {
        console.warn('L\'élément avec le titre "Recherche catalogue" n\'a pas été trouvé.');
    }

    // Ensure other items are not set as active or expanded
    var otherItems = document.querySelectorAll('li a[title]:not([title="Recherche catalogue"])');
    otherItems.forEach(function(item) {
        item.parentElement.classList.remove("active");
        item.setAttribute("aria-expanded", "false");
    });

    // Activate the corresponding tab pane
    var catalogSearchPane = document.querySelector('div#catalog_search');
    if (catalogSearchPane) {
        catalogSearchPane.classList.add("active");
    }

    // Deactivate other tab panes
    var otherPanes = document.querySelectorAll('div.tab-pane:not(#catalog_search)');
    otherPanes.forEach(function(pane) {
        pane.classList.remove("active");
    });
});

//Activate the 0XX tab
document.addEventListener("DOMContentLoaded", function() {
    // Select the element with id "tab0XX_panel"
    var tabPanel = document.getElementById("tab0XX_panel");

    // Check if the element exists
    if (tabPanel) {
      // Add the "active" class to the tab-pane
      tabPanel.classList.add("active");
    }
  });

//Masquer la virgule au niveau de l'auteur (affichage détails biblio
// Sélectionner l'élément avec la classe 'authordates'
var authorDates = document.querySelector('.authordates');
// Remplacer la virgule par une chaîne vide
if (authorDates) {
    authorDates.textContent = authorDates.textContent.replace(',', '');
}



///////////////YANDEV IT///////////////////
// Récupérer la valeur de l'attribut lang de la balise <html>
var lang = document.documentElement.lang;

// Sélectionner la balise <span> avec la classe 'label' à l'intérieur de 'results_summary uniform_title'
var labelSpan = document.querySelector('.results_summary.uniform_title .label');

// Vérifier la langue et changer le texte en conséquence
if (labelSpan) {
    if (lang === "fr-FR") {
        labelSpan.textContent = "Titre originale : ";
    } else if (lang === "en") {
        labelSpan.textContent = "Original title : ";
    } else if (lang === "ar-Arab") {
        labelSpan.textContent = " :العنوان الأصلي";
    }
}
///////////////YANDEV IT///////////////////
///////////////260 - $e - $f Ponctuation///////////////
////////////////////START/////////////////////////////
document.addEventListener("DOMContentLoaded", function() {
    // Function to fill subfields
    function fillSubfields() {
        // Use attribute selectors to get the input fields
        const subfieldE = document.querySelector('input[id*="tag_260_subfield_e"]');
        const subfieldF = document.querySelector('input[id*="tag_260_subfield_f"]');
        const subfieldV = document.querySelector('input[id*="tag_260_subfield_v"]');
        const subfieldW = document.querySelector('input[id*="tag_260_subfield_w"]');

        // Check if subfield E or F exists
        if (subfieldE || subfieldF) {
            const eValue = subfieldE ? subfieldE.value.trim() : "";
            const fValue = subfieldF ? subfieldF.value.trim() : "";

            // If either subfield E or F contains parentheses, clear subfields V and W
            if (eValue.includes('(') || eValue.includes(')') || fValue.includes('(') || fValue.includes(')')) {
                if (subfieldV) {
                    subfieldV.value = ""; // Clear subfield V
                }
                if (subfieldW) {
                    subfieldW.value = ""; // Clear subfield W
                }
            } else {
                // If subfield E is not empty, fill subfields V and W
                if (eValue !== "") {
                    if (subfieldV) {
                        subfieldV.value = "("; // Fill subfield V with "("
                    }
                    if (subfieldW) {
                        subfieldW.value = ")"; // Fill subfield W with ")"
                    }
                } else {
                    // Clear subfields V and W if subfield E is empty
                    if (subfieldV) {
                        subfieldV.value = ""; // Clear subfield V
                    }
                    if (subfieldW) {
                        subfieldW.value = ""; // Clear subfield W
                    }
                }
            }
        } else {
            console.error("Subfield E or F does not exist.");
        }
    }

    // Call the function to fill the subfields
    fillSubfields();

    // Add an event listener to subfield E and F to trigger the function on input change
    const subfieldE = document.querySelector('input[id*="tag_260_subfield_e"]');
    const subfieldF = document.querySelector('input[id*="tag_260_subfield_f"]');
    if (subfieldE) {
        subfieldE.addEventListener('input', fillSubfields);
    }
    if (subfieldF) {
        subfieldF.addEventListener('input', fillSubfields);
    }
});
/////////////////////END//////////////////////////////
// Vérifier la langue de la page
var lang = document.documentElement.lang;

// Sélectionner la div cible
var catalogueDetailBiblio = document.getElementById('catalogue_detail_biblio');

// Appliquer les styles RTL si la langue est ar-AR
if (lang === "ar-Arab" || lang === "ar") {
    if (catalogueDetailBiblio) {
        catalogueDetailBiblio.style.direction = "rtl";
        catalogueDetailBiblio.style.textAlign = "right";
    }
}


///////////008 - U - Fondation du Roi Abdul-Aziz Al Saoud//////////
///////////////START/////////////

//////////////END///////////////


////////////YANDEV IT/////////////////
///////////TRANSLATION SECTION////////
/////////////////START///////////////
$(document).ready(function() {
    // Ajouter d'exemplaire
    $("label span[title='Source of classification or shelving scheme']").text("Source de classification");
    $("label span[title='Damaged status']").text("État endommagé");
    $("label span[title='Use restrictions']").text("Restrictions d'utilisation");
    $("label span[title='Home library']").text("Bibliothèque domicile");
    $("label span[title='Current library']").text("Bibliothèque actuelle");
    $("label span[title='Shelving location']").text("Emplacement des étagères");
    $("label span[title='Date acquired']").text("Date d'acquisition");
    $("label span[title='Cost, normal purchase price']").text("Coût, prix d'achat normal");
    $("label span[title='Serial Enumeration / chronology']").text("Énumération / chronologie");
    $("label span[title='Full call number']").text("Côte");
    $("label span[title='Barcode']").text("Code à barre");
    $("label span[title='Copy number']").text("Numéro de copie");
    $("label span[title='Price effective from']").text("Prix en vigueur à partir de");
    $("label span[title='Non-public note']").text("Note interne");
    $("label span[title='Koha item type']").text("Type d'exemplaire");
    $("label span[title='Public note']").text("Note publique");
  	$("input[name='add_duplicate_submit']").val("Ajouter et dupliquer");
});
/////////////////END///////////////


function getBasketNo() {
        var params = new URLSearchParams(window.location.search); 
        return params.get('basketno'); 
    }

    function checkUrlAndInsertLink() {
        var currentUrl = window.location.href; 
        
        var regex = /http:\/\/192\.168\.2\.81:8001\/cgi-bin\/koha\/acqui\/basket\.pl\?basketno=\d+/;

        if (regex.test(currentUrl)) {
            var basketno = getBasketNo(); 
            
            if (basketno) {
                var newHref = 'http://192.168.2.81/module/suggestion/printbasket.php?basketno=' + basketno;

                var newLink = document.createElement('a');
                newLink.setAttribute('class', 'btn btn-default');
                newLink.setAttribute('href', newHref); // Set the constructed href
                newLink.innerHTML = '<i class="fa fa-download"></i> Exporter Excel'; 

                var btnGroup = document.querySelector('.btn-group');

                if (btnGroup) {
                    btnGroup.insertBefore(newLink, btnGroup.children[1]);
                }
            } else {
                console.log('basketno not found in the URL.');
            }
        } else {
            console.log('URL does not match the expected pattern.');
        }
    }

    checkUrlAndInsertLink();
function getInvoiceId() {
    var params = new URLSearchParams(window.location.search); 
    return params.get('invoiceid'); 
}

function checkUrlAndInsertLinkForInvoice() {
    var currentUrl = window.location.href; 
    
    // Regex for the invoice URL pattern
    var regex = /http:\/\/192\.168\.2\.81:8001\/cgi-bin\/koha\/acqui\/invoice\.pl\?invoiceid=\d+/;

    if (regex.test(currentUrl)) {
        var invoiceid = getInvoiceId(); 
        
        if (invoiceid) {
            // Construct the new href with the invoiceid
            var newHref = 'http://192.168.2.81/module/suggestion/printinvoice.php?invoiceid=' + invoiceid;

            var newLink = document.createElement('a');
            newLink.setAttribute('class', 'btn btn-default');
            newLink.setAttribute('href', newHref); // Set the constructed href
            newLink.innerHTML = '<i class="fa fa-download"></i> Exporter Excel'; 

            // Find the label element by id
            var showAllDetailsLabel = document.querySelector('label[for="show_all_details"]');

            if (showAllDetailsLabel) {
                // Insert the new link after the label
                showAllDetailsLabel.parentNode.insertBefore(newLink, showAllDetailsLabel.nextSibling);
            }
        } else {
            console.log('invoiceid not found in the URL.');
        }
    } else {
        console.log('URL does not match the expected pattern.');
    }
}

checkUrlAndInsertLinkForInvoice();


//////////////////////Leader 000 - Valeur par défaut/////////////////
/////////////////////////////////START//////////////////////////////
document.addEventListener("DOMContentLoaded", function() {
  // Sélectionne l'élément <select> avec id="f18"
  const selectElement = document.getElementById("f18");

  if (selectElement) {
    // Trouve l'option avec value="a" et retire la sélection
    const optionA = selectElement.querySelector('option[value="a"]');
    if (optionA) {
      optionA.selected = false;
    }

    // Trouve l'option avec value="i" et la sélectionne
    const optionI = selectElement.querySelector('option[value="i"]');
    if (optionI) {
      optionI.selected = true;
    }
  } else {
    console.error("L'élément <select> avec l'id 'f18' n'a pas été trouvé.");
  }
});

/////////////////////////////////END//////////////////////////////

//////////////////////Leader 008 - Valeur par défaut/////////////////
/////////////////////////////////START//////////////////////////////
document.addEventListener("DOMContentLoaded", function() {
    // Set a timeout to allow for any delayed rendering of the pop-up
    setTimeout(function() {
        // Select the <select> element with id="f33"
        const selectElement = document.getElementById("f33");

        // Check if the select element exists
        if (selectElement) {
            // Find the option with value="|"
            const optionPipe = selectElement.querySelector('option[value="|"]');

            if (optionPipe) {
                // Set the option with value="|" as selected
                optionPipe.selected = true;

                // Optionally trigger the change event to execute the onchange function
                selectElement.dispatchEvent(new Event('change'));
            } else {
                console.warn('Option with value "|" not found in <select> element.');
            }
        } else {
            console.error("The <select> element with id 'f33' was not found.");
        }
    }, 500); // Delay in milliseconds (500ms)
});


/////////////////////////////////END//////////////////////////////
/////////////////008 - Default value : Source de catalogage//////////////
//////////////////////////START/////////////////////////////
document.addEventListener("DOMContentLoaded", function() {
    // Function to update the select element
    function updateSelectF39() {
        // Select the <select> element with id="f39"
        const selectElement = document.getElementById("f39");

        // Check if the select element exists
        if (selectElement) {
            // Find the option with value="u"
            const optionU = selectElement.querySelector('option[value="u"]');

            if (optionU) {
                // Update the text content of the option
                optionU.textContent = "u - Fondation du Roi Abdul-Aziz Al Saoud";

                // Optionally trigger the change event to execute the onchange function
                selectElement.dispatchEvent(new Event('change'));
            } else {
                console.warn('Option with value "u" not found in <select> element.');
            }
        } else {
            console.error("The <select> element with id 'f39' was not found.");
        }
    }

    // Function to repeatedly check for the select element
    function waitForSelectElement() {
        const selectElement = document.getElementById("f39");
        if (selectElement) {
            updateSelectF39(); // Call the update function when found
        } else {
            setTimeout(waitForSelectElement, 100); // Retry every 100ms
        }
    }

    // Start waiting for the <select> element to be available
    waitForSelectElement();
});



///////////////////////////END/////////////////////////////

//////////////////////Zone locale 912 - Intégration date de catalogage/////////////////
/////////////////////////////////START//////////////////////////////
document.addEventListener("DOMContentLoaded", function() {
  // Sélectionne l'élément dont l'ID contient "tag_912_subfield_2"
  const inputDate = document.querySelector('[id*="tag_912_subfield_2"]');

  // Vérifie si l'élément existe
  if (inputDate) {
    // Change le type de l'input pour qu'il devienne un champ de sélection de date
    inputDate.setAttribute("type", "date");
  }
});
////////////////////////////////////////PARTIE 2 - Module Autorité/////////////////////////::
document.addEventListener("DOMContentLoaded", function() {
    // Sélectionner l'élément avec l'id 'mainmain_heading'
    const tabPane = document.getElementById("mainmain_heading");

    // Vérifier si l'élément existe
    if (tabPane) {
        // Ajouter la classe 'active' à l'élément
        tabPane.classList.add("active");
    } else {
        console.error("L'élément avec l'id 'mainmain_heading' n'a pas été trouvé.");
    }
});
/////////////////////////////////END//////////////////////////////
//////////////////////////////INVOICES - Restore active tab//////
/////////////////////////////START//////////////////////////////
document.addEventListener("DOMContentLoaded", function() {
    // Select the div with the id "opened_panel"
    const tabPanel = document.getElementById("opened_panel");
  	const tabPanel2 = document.getElementById("bibs_panel");
  	const tabPanel3 = document.getElementById("supplier_search");
  	const tabPanel4 = document.getElementById("reports_panel");
  	const tabPanel5 = document.getElementById("subscription_info_panel");
	const tabPanel6 = document.querySelector("div[id*='subscription-year']");
  const tabPanel7 = document.querySelector("div[id*='shelves_tab_panel']");

    
    // Check if the element exists
    if (tabPanel) {
        // Add the "active" class
        tabPanel.classList.add("active");
    }
  	if(tabPanel2){
      	 tabPanel2.classList.add("active");
    }
  	if(tabPanel3){
      	 tabPanel3.classList.add("active");
    }
  if(tabPanel4){
      	 tabPanel4.classList.add("active");
    }
  if(tabPanel5){
      	 tabPanel5.classList.add("active");
    }
  if(tabPanel6){
      	 tabPanel6.classList.add("active");
    }
  if(tabPanel7){
      	 tabPanel7.classList.add("active");
    }
});
/////////////////////////////END///////////////////////////////
// Sélectionner l'élément <a> par son texte
const link = document.querySelector('a[href="/cgi-bin/koha/changelanguage.pl?language=ar-Arab"]');

// Vérifier si l'élément existe
if (link) {
    // Modifier le texte de l'élément
    link.textContent = 'العربية';
}
//document.getElementById('uploadfile_tab-tab').setAttribute('aria-expanded', 'true');

////////// facture champs suplementair ///////////////////////////////////
// Wait for the DOM content to load before executing the script
document.addEventListener("DOMContentLoaded", function() {
  // Replace the "Check" input field with a textarea
  var checkField = document.getElementById('additional_field_5');
  if (checkField) {
    var checkTextarea = document.createElement('textarea');
    checkTextarea.id = checkField.id;
    checkTextarea.name = checkField.name;
    checkTextarea.value = checkField.value;
    checkField.parentNode.replaceChild(checkTextarea, checkField);
  }

  // Replace the "Note" input field with a textarea
  var noteField = document.getElementById('additional_field_3');
  if (noteField) {
    var noteTextarea = document.createElement('textarea');
    noteTextarea.id = noteField.id;
    noteTextarea.name = noteField.name;
    noteTextarea.value = noteField.value;
    noteField.parentNode.replaceChild(noteTextarea, noteField);
  }

  // Replace the "Note 2" input field with a textarea
  var note2Field = document.getElementById('additional_field_4');
  if (note2Field) {
    var note2Textarea = document.createElement('textarea');
    note2Textarea.id = note2Field.id;
    note2Textarea.name = note2Field.name;
    note2Textarea.value = note2Field.value;
    note2Field.parentNode.replaceChild(note2Textarea, note2Field);
  }
});



///////////////////////////////////////Periodique/////////////////////////

//////////////////////////////////////Acquisitions////////////////////////

////////////////////////////////////////////////////////////////////////

/////////////////////////////////////RESULTATS///////////////////////////
document.querySelectorAll('.results_format .label').forEach(label => {
  label.textContent = label.textContent.replace(';', '');
});
////////////////////////////////////////////////////////////////////////
