package formik;
import react.React.*;
import haxe.extern.EitherType;
/**
 * ...
 * @author axel@cunity.me
 */

 //typedef Values = Dynamic;
 
 typedef FormikValues = StringMap<Any>
 
 typedef FormikErrors<Values> = EitherType<StringMap<Any>, String>
 
 typedef FormikTouched<Values> = EitherType<StringMap<Any>, String>
 
 typedef FormikState<Values> =
 {
	 values:Values,
	 ?error:Any,
	 errors:FormikErrors<Values>,
	 touched:FormikTouched<Values>,
	 isValidating:Bool,
	 isSubmitting:Bool,
	 ?status:Any,
	 submitCount:Int
 }
 
 typedef FormikComputedProps<Values> =
 {
    var dirty(default, null):Bool;
    var isValid(default, null):Bool;
    var initialValues(default, null):Values;
}

typedef FormikActions<Values> {
    setStatus(status?: any): void;
    setError(e: any): void;
    setErrors(errors: FormikErrors<Values>): void;
    setSubmitting(isSubmitting: boolean): void;
    setTouched(touched: FormikTouched<Values>): void;
    setValues(values: Values): void;
    setFieldValue(field: keyof Values & string, value: any, shouldValidate?: boolean): void;
    setFieldError(field: keyof Values & string, message: string): void;
    setFieldTouched(field: keyof Values & string, isTouched?: boolean, shouldValidate?: boolean): void;
    validateForm(values?: any): void;
    validateField(field: string): void;
    resetForm(nextValues?: any): void;
    submitForm(): void;
    setFormikState<K extends keyof FormikState<Values>>(f: (prevState: Readonly<FormikState<Values>>, props: any) => Pick<FormikState<Values>, K>, callback?: () => any): void;
}