package org.mk4h.conversion;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.ValueConverter;
import org.eclipse.xtext.conversion.impl.AbstractToStringConverter;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.conversion.IValueConverter;

public class PuddleValueConverterService extends DefaultTerminalConverters {
	@ValueConverter(rule = "org.mk4h.Puddle.SIGNED_INT")
	public IValueConverter<Integer> SignedInt() { 
		return new AbstractToStringConverter<Integer>() {
			@Override
			protected Integer internalToValue(String string, INode node) {
				Integer value = Integer.valueOf(string.substring(1));
				return string.charAt(0) == '+' ? value : -value;
			}
	   };
	}
	
//	@ValueConverter(rule = "org.mk4h.Puddle.QUOTED_ID")
//	public IValueConverter<String> QuotedID() { 
//		return new AbstractToStringConverter<String>() {
//			@Override
//			protected String internalToValue(String string, INode node) {
//				return string.substring(1, string.length() - 1);
//			}
//	   };
//	
//	}
	
}


