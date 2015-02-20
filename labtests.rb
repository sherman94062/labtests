require 'rubygems'
require 'date'

# regular expressions for the common lab test values
# test name - value - unit of measure - test result range
testsre = [
  /(BUN\/Creatinine ratio[^0-9]+)([0-9\.]+)(.*)$/,
  /(GFR African American[^0-9]+)([0-9\.]+)(.*)$/,
  /(GFR non-African American[^0-9]+)([0-9\.]+)(.*)$/,
  /(Normal RBC morphology[^0-9]+)([0-9\.]+)(.*)$/,
  /(Seg \%[^0-9]+)([0-9\.]+)(.*)$/,
  /(Absolute neutrophil count, manual \(ANC[^0-9]+)([0-9\.]+)(.*)$/,
  /(Alanine aminotransferase[^0-9]+)([0-9\.]+)(.*)$/,
  /(Albumin measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Albumin\/Globulin ratio[^0-9]+)([0-9\.]+)(.*)$/,
  /(Alkaline phosphatase[^0-9]+)([0-9\.]+)(.*)$/,
  /(Anion gap measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Aspartate aminotransferase[^0-9]+)([0-9\.]+)(.*)$/,
  /(Basophil count \(BA \#\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Basophil, percent \(BA \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Basophil, percent \(man\) \(Basophil \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Bicarbonate measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Bilirubin, total measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Blast, percent \(manual\) \(Blasts \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Calcium measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Chloride measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Chloride measurement \(Chloride\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Creatinine measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Creatinine ratio[^0-9]+)([0-9\.]+)(.*)$/,
  /(Eosinophil count \(EO \#\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Eosinophil, percent \(EO \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Eosinophil, percent \(man\) \(Eosinophil \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Globulin measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Glucose measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Hematocrit determination[^0-9]+)([0-9\.]+)(.*)$/,
  /(Hemoglobin determination[^0-9]+)([0-9\.]+)(.*)$/,
  /(Lactate dehydrogenase[^0-9]+)([0-9\.]+)(.*)$/,
  /(Lymphocyte count \(LY \#\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Lymphocyte, percent \(LY \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Lymphocyte, percent \(man\) \(Lymphocyte \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Mean corpuscular hemoglobin[^0-9]+)([0-9\.]+)(.*)$/,
  /(Mean corpuscular volume[^0-9]+)([0-9\.]+)(.*)$/,
  /(Metamyelocyte, percent \(manual\) \(Metamyelocyte \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Monocyte count \(MO \#\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Monocyte, percent \(man\) \(Monocyte \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Monocyte, percent \(MO \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Myelocyte, percent \(manual\) \(Myelocyte \%\)[^0-9]+)([0-9\.]+)(.*)$/, 
  /(Neutrophil band, percent \(Band \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Neutrophil count[^0-9]+)([0-9\.]+)(.*)$/,
  /(Neutrophil, percent \(Neu \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Normocytic\/Normochromic[^0-9]+)([0-9\.]+)(.*)$/,
  /(Nucleated RBC \(manual\) \(NRBC \(M\)\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Platelet count \(PLT\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Plt Est \(Platelet estimate\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Potassium measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Promyelocyte \% \(Manual\) \(Promyelocyte \%\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Prostate specific antigen[^0-9]+)([0-9\.]+)(.*)$/,
  /(Protein measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Red blood cell count \(RBC\)[^0-9]+)([0-9\.]+)(.*)$/,
  /(Red cell distribution width[^0-9]+)([0-9\.]+)(.*)$/,
  /(Sodium measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(Urea nitrogen measurement[^0-9]+)([0-9\.]+)(.*)$/,
  /(White blood cell count \(WBC\)[^0-9]+)([0-9\.]+)(.*)$/,
]

datere = /Lab Results for (.*)/
currentDate = ""
# flatten the pdf file using the pdf2txt ruby script
File.open('HealthRecords.pdf.txt').each_line do |li|
  if (match1 = li.match datere)
    # each line of the output has the date for the test so trends can be identified through aggregation
    currentDate = Date.parse(match1[1]).strftime("%Y-%m-%d")
  end
  testsre.each_with_index do |item, index|
    if (match2 = li.match item)
      printf("%s\t%s\t%s\t%s\t%s\n",currentDate,match2[1],match2[2],match2[3],match2[4])
    end
  end
end
