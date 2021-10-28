package react;

import haxe.extern.EitherType;
import react.ControlTypes.InputProps;
import react.ReactComponent.ReactFragment;
import react.ReactMacro.jsx;

typedef IntlConfig = {
	locale:String,
	?currency:String
}

typedef CurrencyInputProps = {
	>IntlConfig,
	>InputProps,
    /**
     * Allow decimals
     *
     * Default = true
     */
    ?allowDecimals: Bool,

    /**
     * Allow user to enter negative value
     *
     * Default = true
     */
    ?allowNegativeValue: Bool,

    /**
     * Component id
     */
    ?id: String,

    /**
     *  Maximum characters the user can enter
     */
    ?maxLength: Int,

    /**
     * Custom component
     *
     * Default = <input/>
     */
    //customInput: ElementType;

    /**
     * Limit length of decimals allowed
     *
     * Default = 2
     */
    ?decimalsLimit: Int,

    /**: 
     * Specify decimal scale for padding/trimming
     *
     * Example:
     *   1.5 -> 1.50
     *   1.234 -> 1.23
     */
    ?decimalScale: Float,

    /**
     * Default value if not passing in value via props
     */
    ?defaultValue: String,

    /**
     * Disabled
     *
     * Default = false
     */
    ?disabled: Bool,

    /**
     * Value will always have the specified length of decimals
     *
     * Example:
     *   123 -> 1.23
     *
     * Note: This formatting only happens onBlur
     */
    ?fixedDecimalLength: Int,

    /**
     * Handle change in value
     */
    ?onValueChange: String->String->Void,
      //values: CurrencyInputOnChangeValues
    //) :Void,

    /**
     * Include a prefix eg. £
     */
    ?prefix: String,

    /**
     * Include a suffix eg. €
     */
    ?suffix: String,

    /**
     * Incremental value change on arrow down and arrow up key press
     */
    ?step: Int,

    /**
     * Separator between integer part and fractional part of value.
     *
     * This cannot be a number
     */
    decimalSeparator: String,

    /**
     * Separator between thousand, million and billion
     *
     * This cannot be a number
     */
    groupSeparator: String,

    /**
     * Disable auto adding separator between values eg. 1000 -> 1,000
     *
     * Default = false
     */
    ?disableGroupSeparators: Bool,

    /**
     * Disable abbreviations (m, k, b)
     *
     * Default = false
     */
    ?disableAbbreviations: Bool,

    /**
     * International locale config, examples:
     *   { locale: 'ja-JP', currency: 'JPY' }
     *   { locale: 'en-IN', currency: 'INR' }
     *
     * Any prefix, groupSeparator or decimalSeparator options passed in
     * will override Intl Locale config
     */
    ?intlConfig: IntlConfig,

    /**
     * Transform the raw value form the input before parsing
     */
    ?transformRawValue: String->String
  }

@:jsRequire('react-currency-input-field', 'default')
class CurrencyInputFactory{
	public static function render(props:CurrencyInputProps):ReactFragment{
		return jsx('<input type="text" ${...props}/>');
		
		/*nputMode="decimal"
		name=${name,
		className=${p.className, onChange=${onChange} onBlur: handleOnBlur, onFocus: handleOnFocus, onKeyDown: handleOnKeyDown, onKeyUp: handleOnKeyUp, placeholder: placeholder,
		disabled: disabled, value: getRenderValue()name=')*/
	}
}