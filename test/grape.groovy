@Grab(group='org.apache.commons', module='commons-lang3', version='3.6')
import org.apache.commons.lang3.StringUtils

if (new File(System.getProperty('user.home'), '.groovy/grapes').listFiles().size() == 0) {
    System.exit 1
} else {
    System.exit 0
}
