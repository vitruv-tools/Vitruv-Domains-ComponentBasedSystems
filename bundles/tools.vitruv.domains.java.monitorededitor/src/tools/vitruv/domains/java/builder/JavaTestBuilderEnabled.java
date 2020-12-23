package tools.vitruv.domains.java.builder;

import tools.vitruv.framework.ui.monitorededitor.TestBuilderEnabled;

public class JavaTestBuilderEnabled extends TestBuilderEnabled {

    public JavaTestBuilderEnabled() {
        super(new VitruviusJavaBuilderApplicator());
    }

}
