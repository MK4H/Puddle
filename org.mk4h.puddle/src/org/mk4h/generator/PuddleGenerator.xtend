/*
 * generated by Xtext 2.25.0
 */
package org.mk4h.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.mk4h.puddle.*
import java.lang.Math

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class PuddleGenerator extends AbstractGenerator {
	
	def getIndent(int count) {
		val builder = new StringBuilder
		for (var idx = 0; idx < count; idx++) {
			builder.append("	")
		}
		
		builder.toString
	}
	
	def getLilypondOctave(int octave) {
		val sign = if (octave < 0) ',' else '\''
		val builder = new StringBuilder
		for (var idx = 0; idx < Math.abs(octave); idx++) {
			builder.append(sign)
		}
		
		builder.toString
		
	}

	def lilypond(Song it) {
		val keyName = it.keyName ?: "c"
		val keyType = it.keyType ?: "major"
		val timeNum = if (it.timeOverride) it.timeNum else 4
		val timeDen = if (it.timeOverride) it.timeDen else 4
		val baseOctave = if (it.octaveOverride) it.baseOctave else 0
		val defaultDuration = if (it.durationOverride) it.defaultDuration else 4
'''\version "2.18.2"

\header {
	title = "«name»"
}

\score {
	<< 
	\new Staff {
		\key «keyName» \«keyType»
		\time «timeNum»/«timeDen»
		
		\absolute {
«entries.map[lilypondNotes(baseOctave, defaultDuration, 3)].join('\n')»
		}
	}
	
	\addlyrics {
		«entries.map[lilypondLyrics()].join(' ')»
	}
	>>
}
'''
	}
	
	def dispatch lilypondNotes(Note it, int baseOctave, int defaultDuration, int indent) {
		val in = getIndent(indent)
		val oct = getLilypondOctave(baseOctave + it.octave)
		val dur = String.valueOf(it.duration != 0 ? it.duration : defaultDuration)
		'''«in»«pitch»«oct»«dur»'''
	}
	
	def dispatch lilypondLyrics(Note it) {
		'''"«it.lyrics ?: ""»"'''
	}
	

	def dispatch lilypondNotes(PhraseReference it, int baseOctave, int defaultDuration, int indent) {
		val in = getIndent(indent)
		val phrase = it.phrase
		val resBaseOctave = if (phrase.octaveOverride) phrase.baseOctave else baseOctave
		val resDuration = if (phrase.durationOverride) phrase.defaultDuration else defaultDuration
		'''«in»''' + phrase.entries.map[lilypondNotes(resBaseOctave, resDuration, 0)].join(' ')
	}
	
	def dispatch lilypondLyrics(PhraseReference it) {
		it.phrase.entries.map[lilypondLyrics()].join(' ')
	}
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		for (o: resource.contents) {
			val s = o as Song
			fsa.generateFile(s.name + ".ly", s.lilypond())
		}
		
	}
}