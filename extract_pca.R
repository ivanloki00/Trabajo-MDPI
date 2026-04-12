load("09B_Diabetes.RData")
library(PLSandO)

descDiabetes = data.frame("variable" = colnames(Diabetes_B),
                      "tipo" = c(rep("numerical", 8), rep("categorical", 2), rep("numerical", 3)),
                      "descripcion" = c("Numero de embarazos previos",
                                        "Glucosa en plasma (mg/dL)",
                                        "Presion arterial diastolica (mm Hg)",
                                        "Grosor del pliegue cutaneo del triceps (mm)",
                                        "Insulina serica a las 2 horas de la prueba (mug/ml)",
                                        "Indice de Masa Corporal",
                                        "Puntuacion de la carga genetica basada en la historia familiar",
                                        "Edad de la paciente en anyos",
                                        "Si tiene o no diabetes (neg=Sano, pos=Afectado)",
                                        "Dieta vegana (Yes=Vegano, No=Dieta omnivora)",
                                        "Niveles de colesterol total en sangre (mg/dL)",
                                        "Niveles de leptina serica (ng/mL), regula saciedad",
                                        "Proteina C Reactiva en sangre (mg/L), mide inflamacion"), stringsAsFactors = FALSE)

vars_pca = descDiabetes$variable[descDiabetes$tipo == "numerical"]

diabetesPCA = Diabetes_B[, vars_pca]
mipca = pca(diabetesPCA, ncomp = 4, algo = "nipals", scaling = "standard")

print("Varianza Explicada:")
print(mipca$explVar[1:4,])

print("------------------------------------------")
print("Loadings (Pesos) de los Componentes Principales:")
print(mipca$loadings)

print("------------------------------------------")
print("Variables principales que definen cada PC:")
for (i in 1:4){
    cat("\nComponente ", i, ":\n")
    # Mostrar variables ordenadas por valor absoluto de carga (loading)
    cargas <- mipca$loadings[,i]
    cargas_ord <- sort(abs(cargas), decreasing = TRUE)
    
    # Extraer aquellas con importancia relativa "alta" y mostrar con signo
    variables_clave <- names(head(cargas_ord, 5))
    print(cargas[variables_clave])
}
