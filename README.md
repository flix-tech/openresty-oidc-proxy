# Usage
You need to configure your credentials and upstream identity provider by providing a `env.sh`. `env.sh.example` can serve as a reference.

There is a development environment baked in that can be used by running make:

    source env.sh
    make
    
The authentication proxy should now be accessible at `:22820`